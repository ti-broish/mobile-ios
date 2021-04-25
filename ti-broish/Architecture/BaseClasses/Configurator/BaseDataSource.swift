//
//  BaseDataSource.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 25.04.21.
//

import UIKit

/// Protocol establishing the base data source properties and methods in relation with `ViewConfigurator`.
/// Usable by both `UITableView` and `UICollectionView`.
public protocol BaseDataSource {
    
    /// List of reuseIdentifiers of header and footer views.
    var headerFooterReuseIdentifiers: [String] { get }
    
    /// List of reuseIdentifiers of cell views.
    var reuseIdentifiers: [String] { get }
    
    /// Provides the number of sections in your table/collection view
    /// Defaults to 1
    var numberOfSections: Int { get }
    
    /// Provides the number of table/collection view cells for the given section
    ///
    /// - Parameter section: The given section
    /// - Returns: The number of cells from the viewModel
    func numberOfCellsInSection(_ section: Int) -> Int?
    
    /// Provides the viewConfigurator for your configurable table/collection view cell
    ///
    /// - Parameter index: The index path for the current cell
    /// - Parameter section: The section path for the current cell
    /// - Returns: A configurator from the viewModel
    func viewConfigurator(at index: Int, in section: Int) -> ViewConfigurator?
    
    /// Provides the viewConfigurator for your configurable header view.
    /// - Parameter section: The given section
    func headerViewConfigurator(in section: Int) -> ViewConfigurator?
    
    /// Provides the viewConfigurator for your configurable footer view.
    /// - Parameter section: The given section
    func footerViewConfigurator(in section: Int) -> ViewConfigurator?
    
}

// MARK: - BaseDataSource+Defaults
public extension BaseDataSource {
    
    var headerFooterReuseIdentifiers: [String] {
        return []
    }
    
    var reuseIdentifiers: [String] {
        return []
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func viewConfigurator(at index: Int, in section: Int) -> ViewConfigurator? {
        return nil
    }
    
    func headerViewConfigurator(in section: Int) -> ViewConfigurator? {
        return nil
    }
    
    func footerViewConfigurator(in section: Int) -> ViewConfigurator? {
        return nil
    }
    
}
