//
//  ApplicationConfigurator.swift
//  AirLST
//
//  Created by Dmitry Zawadksy on 12.01.2018.
//  Copyright © 2018 LetMeCode. All rights reserved.
//

import QuickLook
import UIKit

protocol ApplicationConfiguratorInput {
    func configureInitialSettings(with window: UIWindow)
}

class ApplicationConfigurator {

    private func configureAppearance(for window: UIWindow?) {

        // TODO: Remove before implementing dark mode")
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }

    private func configureFrameworks() {
    }
    
    func swizzleMethods() {
    }

    func clearOldData() {
        // if !Storage.sharedManager.hasRunBefore {
        //     Storage.sharedManager.clearAllData()
        //     Storage.sharedManager.setHasRunBefore()
        // }
    }
}

// MARK: - ApplicationConfiguratorInput
extension ApplicationConfigurator: ApplicationConfiguratorInput {

    func configureInitialSettings(with window: UIWindow) {
        clearOldData()
        configureAppearance(for: window)
        swizzleMethods()
        configureFrameworks()
    }
}
