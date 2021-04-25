//
//  BaseViewConfigurator.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 25.04.21.
//

import Foundation

import UIKit

public protocol Configurable {
    associatedtype DataType
    
    /// Used if using shouldAttemptOptimization to manage a serial queue for the async operations
    var queue: OperationQueue { get }
    
    /// Defaults to false
    /// ONLY use this if your table/collection view is in desperate need of optimization.. This property
    /// Triggers configurators logic to return the cell immideately and configure it asynchronously later
    /// Should you set this to true override precalculateLayoutWith: and calculate the cell's size so that it guaranteed knows
    /// what its width and height is after the precalculate method. If you already have a fixed size layout (not dynamic)
    /// just override precalculateLayoutWith: with an empty implementation to prevent preconditionFailure
    var shouldAttemptOptimization: Bool { get }
    
    /// Every cell/view should conform to configurable if it needs Data passed to it
    /// example: func configureWith(_ data: String) will take just one string as value
    /// - Parameter data: The data with generic associatedType passed to it
    func configureWith(_ data: DataType)
    
    @discardableResult
    /// !!!Used mainly with shouldAttemptOptimization but can be used even without it. It is called by the configurators only if
    /// shouldAttemptOptimization is set to true but you can use it in your own configurables at your own risk!
    ///
    /// It is used to send a call to your cell/view before configureWith: is called. You should ONLY (AND I MEAN ONLY!) calculate
    /// stuff like width/height and other sizes that you need to manage your layout here. Any adding/removing/binding and so on
    /// should be done in configureWith: !!! Here you just calculate the height for example and set a fixed constraint to your cell
    /// to be able to layout the dynamic data properly. For more info:
    /// https://blog.uship.com/shipping-code/populating-uitableviewcells-asynchronously-to-fix-uitableview-lag/
    ///
    /// - Parameter data: The same data sent to configureWith method (Normally your cell model/viewModel)
    /// - Returns: The calculated size (not used by the configurators but added here for convenience if you need to get it in your own views)
    func precalculateLayoutWith(_ data: DataType) -> CGSize?
}

public extension Configurable {
    var queue: OperationQueue {
        return SerialOperationQueue()
    }
    
    var shouldAttemptOptimization: Bool {
        return false
    }
    
    func precalculateLayoutWith(_ data: DataType) -> CGSize? {
        if shouldAttemptOptimization {
            // If your cell/view already has fixed layout override it with an empty implementation
            preconditionFailure("OVERRIDE precalculateLayoutWith: IF you are using shouldAttempOptimization")
        }
        return nil
    }
}

open class SerialOperationQueue: OperationQueue {
    override init() {
        super.init()
        maxConcurrentOperationCount = 1
    }
}

public protocol ViewConfigurator {
    /// In the case of cells it is the reuseId, in the case of views it can be the nibName if needed
    var reuseIdentifier: String { get }
    
    /// Should be used for didSelect (either row at index path or some custom view logic)
    var didSelectAction: (() -> Void)? { get set }
    
    /// Call the configurator.configure(your cell/view)
    ///
    /// - Parameter view: The UIView/UITableViewCell/UICollectionViewCell that the configurator handles
    func configure(_ view: UIView)
}

open class BaseViewConfigurator<ConfigurableType: Configurable>: ViewConfigurator {
    open class var reuseIdentifier: String { return String(describing: ConfigurableType.self) }
    open var reuseIdentifier: String { return Self.reuseIdentifier }
    open var didSelectAction: (() -> Void)?
    
    open var data: ConfigurableType.DataType
    
    /// Initialize the viewConfigurator with the data of the proper type
    ///
    /// - Parameter data: This Data needs to be the same data as the one the configurableCell expects
    public init(data: ConfigurableType.DataType, didSelectAction: (() -> Void)? = nil) {
        self.data = data
        self.didSelectAction = didSelectAction
    }
    
    open func configure(_ view: UIView) {
        if let configurableView = view as? ConfigurableType {
            if configurableView.shouldAttemptOptimization {
                
                // Precalculate size if dynamic layout is needed by the cell/view. This calls the method in the respective configurableView
                // so that it can have fixed layout after the cell is dequeued but before it is actually configured asynchronously
                configurableView.precalculateLayoutWith(data)
                
                // Store the data because self in some cases is released and is nil
                let blockData = data
                
                // Cancels all ongoing operations if there are any (to avoid multiple queues triggering multiple updates)
                configurableView.queue.cancelAllOperations()
                
                // Create the operation and execute it while accessing the main thread to trigger the configure UI Updates
                let operation = BlockOperation()
                operation.addExecutionBlock { [weak operation] in
                    DispatchQueue.main.sync {
                        // Make sure that the operation isn't canceled  by multiple cellForRow calls
                        guard let operation = operation, !operation.isCancelled else { return }
                        
                        // Configure with the data on the main thread
                        configurableView.configureWith(blockData)
                    }
                }
                
                // Adds the operation to the queue
                configurableView.queue.addOperation(operation)
            } else {
                // In 99% of the cases shouldAttempOptimization will be false and the configure will just configure it automatically
                configurableView.configureWith(data)
            }
        }
    }
}

public extension UITableView {
    
    /// Directly register cells and headerFooterViews with `BaseDataSource` confirming instance.
    /// - Parameter dataSource: `BaseDataSource` confirming instance, containing information for `headerFooterReuseIdentifiers` and `reuseIdentifiers`.
    func register(with dataSource: BaseDataSource) {
        register(headerFooterNames: dataSource.headerFooterReuseIdentifiers)
        register(cellNames: dataSource.reuseIdentifiers)
    }
    
    /// Register an array of cell names <"\(YourCellClass.self)"> to be reused
    ///
    /// - Parameter cellNames: The array of names
    func register(cellNames: [String]) {
        cellNames.forEach {
            register(UINib(nibName: $0, bundle: nil),
                     forCellReuseIdentifier: $0)
        }
    }
    
    /// Register an array of cell names <"\(YourCellClass.self)"> to be reused
    ///
    /// - Parameter cellNames: The array of names
    func register(cellNames: String...) {
        for cellName in cellNames {
            register(UINib.init(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        }
    }
    
    /// Called in cellForRow atIndexPath. Configures the cell and returns it
    ///
    /// - Parameters:
    ///   - configurator: The configurator for the cell (from the viewModel)
    ///   - indexPath: The indexPath for the cell (from the dataSourceMethod - cellForRow)
    /// - Returns: An already configured UITableViewCell
    func configureCell(for configurator: ViewConfigurator, at indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: configurator.reuseIdentifier, for: indexPath)
        configurator.configure(cell)
        return cell
    }
    
    /// Register an array of header names <"\(YourHeaderClass.self)"> to be reused
    ///
    /// - Parameter headerFooterNames: The array of names
    func register(headerFooterNames: [String]) {
        headerFooterNames.forEach {
            register(UINib(nibName: $0, bundle: nil),
                     forHeaderFooterViewReuseIdentifier: $0)
        }
    }
    
    /// Register an array of header names <"\(YourHeaderClass.self)"> to be reused
    ///
    /// - Parameter headerFooterNames: The array of names
    func register(headerFooterNames: String...) {
        for headerFooterName in headerFooterNames {
            register(UINib(nibName: headerFooterName, bundle: nil), forHeaderFooterViewReuseIdentifier: headerFooterName)
        }
    }
    
    /// Called in header or footer for section. Configures a headerFooterView and returns it.
    ///
    /// - Parameter configurator: The configurator for the header/footer (from the viewModel)
    /// - Returns: An already configured UITableViewHeaderFooterView
    func configureHeaderFooter(for configurator: ViewConfigurator) -> UITableViewHeaderFooterView? {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: configurator.reuseIdentifier) else { return nil }
        configurator.configure(headerFooterView)
        return headerFooterView
    }
}

public extension UICollectionView {
    /// Register an array of cell names <"\(YourCellClass.self)"> to be reused
    ///
    /// - Parameter cellNames: The array of names
    func register(cellNames: [String]) {
        for cellName in cellNames {
            register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        }
    }
    
    /// Called in cellForRow atIndexPath. Configures the cell and returns it
    ///
    /// - Parameters:
    ///   - configurator: The configurator for the cell (from the viewModel)
    ///   - indexPath: The indexPath for the cell (from the dataSourceMethod - cellForRow)
    /// - Returns: An already configured UICollectionViewCell
    func configureCell(for configurator: ViewConfigurator, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: configurator.reuseIdentifier, for: indexPath)
        configurator.configure(cell)
        return cell
    }
}
