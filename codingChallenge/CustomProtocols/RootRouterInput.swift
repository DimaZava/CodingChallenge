//
//  RootRouterInput.swift
//  BezrukihNet
//
//  Created by Dmitry Zawadsky on 04/01/2018.
//  Copyright © 2018 BezrukihNet. All rights reserved.
//

import Foundation

protocol RootRouterInput: AnyObject {
    
    var transitionHandler: TransitionController? { get set }
}

extension RootRouterInput {
    
    weak var transitionHandler: TransitionController? {
        return nil
    }
}
