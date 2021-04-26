//
//  HomeScreen
//  HomeScreenRouter.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

import UIKit

class HomeScreenRouter: HomeScreenRouterInput {
    
    var transitionHandler: TransitionController?
    
    func onNeedsToShowDetails(for event: TimelineEvent) {
        let viewController = DetailsScreenViewController(event)
        transitionHandler?.pushModule(viewController)
    }
}
