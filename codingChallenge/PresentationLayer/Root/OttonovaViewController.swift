//
//  OttonovaViewController.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 27.04.2021.
//

import UIKit

class OttonovaViewController: UIViewController {
    
}

extension OttonovaViewController: TransitionController {
    
    func addModuleAsChildAndFill(_ viewController: UIViewController) {
    }
    
    func presentModule(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func presentModuleOnTop(with viewController: UIViewController) {
    }
    
    func pushModule(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Dismiss current module
    /// If module is contained in `UINavigationController` and
    /// is not root controller, then function `popViewController` is called from `UINavigationController`.
    ///
    /// - Parameter animated: true to dismiss module animated
    /// - Parameter popToRoot: true to pop controllers to root
    /// - Parameter completion: Completion if available, *IMPORTANT* won't be called otherwise
    func dismissModule(animated: Bool, popToRoot: Bool, completion: @escaping () -> Void) {
        switch parent {
        case let navigationController as UINavigationController where !navigationController.viewControllers.isEmpty &&
                navigationController.viewControllers.first != self:
            if popToRoot {
                navigationController.popToRootViewController(animated: animated)
            } else {
                navigationController.popViewController(animated: animated)
            }
        case _ where parent?.presentingViewController != nil || parent?.popoverPresentationController != nil:
            dismiss(animated: animated, completion: completion)
        case let navigationController as UINavigationController where !navigationController.viewControllers.isEmpty:
            if popToRoot {
                navigationController.popToRootViewController(animated: animated)
            } else {
                navigationController.popViewController(animated: animated)
            }
        default:
            dismiss(animated: animated, completion: completion)
        }
    }
    
    /// Dismiss current module
    /// If module is contained in `UINavigationController` and
    /// is not root controller, then function `popViewController` is called from `UINavigationController`.
    ///
    /// - Parameter animated: true to dismiss module animated
    /// - Parameter popToRoot: true to pop controllers to root
    @objc
    func dismissModule(animated: Bool, popToRoot: Bool) {
        dismissModule(animated: animated, popToRoot: popToRoot, completion: { })
    }
}
