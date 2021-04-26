//
//  HomeScreenHomeScreenPresenter.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

class HomeScreenPresenter: HomeScreenViewOutput {

    // MARK: Constants
    private let dataService: DataServiceInput = DataService()
    
    // MARK: Properties
    weak var view: HomeScreenViewInput!
    var router: HomeScreenRouter!
    
    // MARK: Lifecycle
    func onViewDidLoad() {
        
        view.setupInitialState()
        
        dataService.profileInfo { [weak self] profileInfoResult in
            
            guard let self = self else { print(CCError.unableToObtainObject.localizedDescription); return }
            
            switch profileInfoResult {
            case .success(let profileContainer):
                break
            case .failure(let error):
                self.view.onError(error)
            }
        }
    }

    func onViewIsReady() {
		view.onViewWillAppear()
    }
}
