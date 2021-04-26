//
//  DetailsScreenDetailsScreenConfigurator.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 27/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

import UIKit

class DetailsScreenConfigurator {

    func configureModuleForViewInput(viewInput: UIViewController) {
        guard let viewController = viewInput as? DetailsScreenViewController else { return }
        configure(viewController: viewController)
    }
    
    private func configure(viewController: DetailsScreenViewController) {
        let presenter = DetailsScreenPresenter()
        presenter.view = viewController
        viewController.output = presenter

        let router = DetailsScreenRouter()
        router.transitionHandler = viewController as? TransitionController
        presenter.router = router
    }
}
