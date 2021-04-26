//
//  HomeScreenHomeScreenConfigurator.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

import UIKit

class HomeScreenConfigurator {

    func configureModuleForViewInput(viewInput: UIViewController) {
        guard let viewController = viewInput as? HomeScreenViewController else { return }
        configure(viewController: viewController)
    }
    
    private func configure(viewController: HomeScreenViewController) {
        let presenter = HomeScreenPresenter()
        presenter.view = viewController
        viewController.output = presenter
        presenter.router = HomeScreenRouter()
        presenter.router.transitionHandler = viewController
    }
}
