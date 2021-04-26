//
//  HomeScreenHomeScreenPresenter.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

class HomeScreenPresenter: HomeScreenViewOutput {

    weak var view: HomeScreenViewInput!
    var router: HomeScreenRouter!
    
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
