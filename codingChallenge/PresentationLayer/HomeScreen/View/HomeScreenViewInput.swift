//
//  HomeScreenHomeScreenViewInput.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

protocol HomeScreenViewInput: AnyObject {
    func setupInitialState()
    func onViewWillAppear()
    func onError(_ error: Error)
}
