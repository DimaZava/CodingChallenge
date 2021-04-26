//
//  DataService.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import Foundation

protocol DataServiceInput {
    
    func profileInfo(result: @escaping (Result<ProfileContainer, Error>) -> Void)
}

class DataService: DataServiceInput {
    
    let apiService: APIServiceInput
    
    init(apiService: APIServiceInput = APIService()) {
        self.apiService = apiService
    }
}
