//
//  DetailsScreenDetailsScreenPresenter.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 27/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

class DetailsScreenPresenter: DetailsScreenViewOutput {

    weak var view: DetailsScreenViewInput!
    var router: DetailsScreenRouter!
    
    func onViewDidLoad() {
        view.setupInitialState()
    }

    func onViewIsReady() {
		view.onViewWillAppear()
    }

    func openSomeModule() {
    	router.openSomeModule()
    }
}
