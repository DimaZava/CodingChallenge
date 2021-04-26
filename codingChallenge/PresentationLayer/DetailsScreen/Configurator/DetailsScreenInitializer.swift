//
//  DetailsScreenDetailsScreenInitializer.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 27/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

import UIKit

class DetailsScreenInitializer: NSObject {

    @IBOutlet private weak var viewController: DetailsScreenViewController!
    
    override func awakeFromNib() {
    	super.awakeFromNib()
        let configurator = DetailsScreenConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
