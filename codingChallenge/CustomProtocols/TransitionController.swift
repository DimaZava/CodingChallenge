//
//  TransitionController.swift
//  dafi
//
//  Created by Dmitry Zawadsky on 15.01.2021.
//  Copyright © 2021 Muehlemann&Popp. All rights reserved.
//

import UIKit

/// Modules transitioning protocol
protocol TransitionController: AnyObject {
    
    /// true if module already in `UINavigationController` and not root
    var isCanPop: Bool { get }
    
    /// Adds module as child and fillst to superview
    ///
    /// - Parameter viewController: ViewControlelr to add
    func addModuleAsChildAndFill(_ viewController: UIViewController)
    
    /// Present given module
    ///
    /// - Parameter name: Main module name
     func presentModule(_ viewController: UIViewController)
    
    /// Present given module on top of window
    ///
    /// - Parameter name: Main module name
     func presentModuleOnTop(with viewController: UIViewController)
    
    /// Push given module
    ///
    /// - Parameter name: Main module name
    func pushModule(_ viewController: UIViewController)
    
    /// Show one of main modules with given name
    ///
    /// - Parameters:
    ///   - name: Main module name
    ///   - completion: completion block with main tab bar controller
    // func showMainModule(with name: MainTabBarViewController.Pages, completion: ((MainTabBarViewController) -> Void)?)
    
    /// Dismiss current module
    /// If module is contained in `UINavigationController` and
    /// is not root controller, then function `popViewController` is called from `UINavigationController`.
    ///
    /// - Parameter animated: true to dismiss module animated
    /// - Parameter popToRoot: true to pop controllers to root
    /// - Parameter completion: Completion if available, *IMPORTANT* won't be called otherwise
    func dismissModule(animated: Bool, popToRoot: Bool, completion: @escaping () -> Void)
    
    /// Dismiss current module
    /// If module is contained in `UINavigationController` and
    /// is not root controller, then function `popViewController` is called from `UINavigationController`.
    ///
    /// - Parameter animated: true to dismiss module animated
    /// - Parameter popToRoot: true to pop controllers to root
    func dismissModule(animated: Bool, popToRoot: Bool)
    
    /// Dismiss current module
    /// If module is contained in `UINavigationController` and
    /// is not root controller, then function `popViewController` is called from `UINavigationController`.
    /// Performed animated.
    ///
    func dismissModule()
    
    /// Dismiss current module's presented controller
    /// Performed animated.
    ///
    func dismissPresentedModule(completion: (() -> Void)?)
    
    /// Pop to desired module, if one is in `UINavigationController` stack
    /// `popToViewController` function called from `UINavigationController`.
    ///
    /// - Parameter moduleInput: Module input
    /// - Parameter animated: true to dismiss module animated
    /// - Parameter configuration: configuration block
    /// - Returns: true, if desired controller's presenter found
    // func pop<ModuleInputType>(to moduleInput: ModuleInputType.Type,
    //                           animated: Bool,
    //                           configuration: ((AnyModuleInputConvertible) -> Void)?) -> Bool
    
    /// Pop to desired module, if one is in `UINavigationController` stack
    /// `popToViewController` function called from `UINavigationController`.
    ///
    /// - Parameter moduleInput: Module input
    /// - Parameter configuration: configuration block
    /// - Returns: true, if desired controller's presenter found
    // func pop<ModuleInputType>(to moduleInput: ModuleInputType.Type,
    //                           configuration: ((AnyModuleInputConvertible) -> Void)?) -> Bool
}

// MARK: - TransitionController + Default
extension TransitionController {
    
    var isCanPop: Bool {
        false
    }
    
    // func showMainModule(with name: MainTabBarViewController.Pages,
    //                     completion: ((MainTabBarViewController) -> Void)? = nil) {
    //     showMainModule(with: name, completion: completion)
    // }
    
    func dismissModule() {
        dismissModule(animated: true, popToRoot: false)
    }
    
    func dismissModule(animated: Bool) {
        dismissModule(animated: animated, popToRoot: false)
    }
    
    func dismissPresentedModule(completion: (() -> Void)? = nil) {
        dismissPresentedModule(completion: completion)
    }
    
    // @discardableResult
    // func pop<ModuleInputType>(to moduleInput: ModuleInputType.Type,
    //                           configuration: ((AnyModuleInputConvertible) -> Void)?) -> Bool {
    //     pop(to: moduleInput, animated: true, configuration: configuration)
    // }
}
