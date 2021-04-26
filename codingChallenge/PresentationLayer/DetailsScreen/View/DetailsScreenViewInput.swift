//
//  DetailsScreenDetailsScreenViewInput.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 27/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

protocol DetailsScreenViewInput: AnyObject {
    func setupInitialState()
    func onViewWillAppear()
    func onError(_ error: Error)
}
