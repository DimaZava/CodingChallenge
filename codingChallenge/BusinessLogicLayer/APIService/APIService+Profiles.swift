//
//  APIService+Profiles.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import Foundation

extension APIService {
    
    func profiles(result: @escaping (Result<Data, Error>) -> Void) {
        requestResource(resource: .profiles,
                        dataCarrier: .parameters(nil),
                        headers: nil,
                        result: result)
    }
    
    func timelineEvents(for profileId: String, result: @escaping (Result<Data, Error>) -> Void) {
        requestResource(resource: .timelineEvents(profileId: profileId),
                        dataCarrier: .parameters(nil),
                        headers: nil,
                        result: result)
    }
    
    func healthPrompts(for profileId: String, result: @escaping (Result<Data, Error>) -> Void) {
        requestResource(resource: .healthPrompts(profileId: profileId),
                        dataCarrier: .parameters(nil),
                        headers: nil,
                        result: result)
    }
}
