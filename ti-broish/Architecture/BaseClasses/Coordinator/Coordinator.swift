//
//  BaseCoordinator.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 24.04.21.
//

import Foundation

class Coordinator {
    
    open private(set) var childCoordinators: [Coordinator] = []
    open weak var parentCoordinator: Coordinator?
    
    /// Unique string value, to easily identify a coordinator
    open var identifier: String?
    
    public init() { }
    
    /// Start The Coordinator !!! SHOULD BE OVERRIDEN IN EACH SUBCLASS !!!
    open func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    /// Finish The Coordinator !!!
    /// The base class automatically handles memory management:
    ///     - removing `self` from childCoordinator's array of the parent coordinator
    /// Subclasses should provide custom navigation action: pop/dimiss/etc...
    open func finish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
    
    /// Adds a child coordinator to the current childCoordinators array
    ///
    /// - Parameter coordinator: the coordinator to add
    open func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    open func addChildCoordinators(_ coordinators: [Coordinator]) {
        coordinators.forEach { addChildCoordinator($0) }
    }
    
    /// Removes a child coordinator if such exists from the childCoordinators array
    ///
    /// - Parameter coordinator: the coordinator to remove
    open func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    /// Removes all child coordinators of a generic type if they exist from the childCoordinators array
    ///
    /// - Parameter type: the type by which the array is filtered
    open func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }
    
    /// Removes all child coordinators from the childCoordinators array
    open func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    /// Returns the first parent coordinator of passed type,
    /// with the possibility to search for specific coordinator with desired identifier
    open func firstParent<T: Coordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        if isCorrectCoordinator(parentCoordinator as? T, with: identifier) {
            return parentCoordinator as? T
        }
        
        return parentCoordinator?.firstParent(of: type, with: identifier)
    }
    
    /// Returns the first child coordinator of passed type, checking the self's child coordinators
    /// with the possibility to search for specific coordinator with desired identifier
    open func firstChildCoordinator<T: Coordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        for coordinator in childCoordinators {
            if isCorrectCoordinator(coordinator as? T, with: identifier) {
                return coordinator as? T
            }
        }
        
        return nil
    }
    
    /// Returns the first child coordinator of passed type, recursively checking all of the child coordinators children
    /// with the possibility to search for specific coordinator with desired identifier
    open func firstChildCoordinatorRecursive<T: Coordinator>(of type: T.Type, with identifier: String? = nil) -> T? {
        for coordinator in childCoordinators {
            if isCorrectCoordinator(coordinator as? T, with: identifier) {
                return coordinator as? T
            }
            
            if !coordinator.childCoordinators.isEmpty {
                return coordinator.firstChildCoordinatorRecursive(of: type, with: identifier)
            }
        }
        
        return nil
    }
    
    /// Check if the given coordinator is not nil (wich means that it is from the correct type),
    /// and than check if the identifier is the correct one
    private func isCorrectCoordinator(_ coordinator: Coordinator?, with identifier: String?) -> Bool {
        guard let coordinator = coordinator else { return false }
        
        return identifier == nil || coordinator.identifier == identifier
    }
    
}

extension Coordinator: Equatable {
    
    public static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}
