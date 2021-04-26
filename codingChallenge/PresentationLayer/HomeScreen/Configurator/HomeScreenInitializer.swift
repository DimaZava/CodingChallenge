//
//  HomeScreenHomeScreenInitializer.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

import UIKit

class HomeScreenInitializer: NSObject {

    @IBOutlet private weak var viewController: HomeScreenViewController!
    
    override func awakeFromNib() {
    	super.awakeFromNib()
        let configurator = HomeScreenConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
