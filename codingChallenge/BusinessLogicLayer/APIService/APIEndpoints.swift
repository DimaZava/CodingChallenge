//
//  APIEndpoints.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import Foundation

enum APIEndpoints {
    
    static var baseURL: URL {
        guard let baseURL = URL(string: "https://freemium.ottonova.de/api") else {
            fatalError(CCError.unableToObtainObject.localizedDescription)
        }
        return baseURL
    }
    
    case profiles
    case timelineEvents(profileId: Int)
    case healthPrompts(profileId: Int)
    case custom(String, HTTPMethod)
    
    var path: String {
        switch self {
        case .profiles:
            return "/user/customer/profiles"
        case .timelineEvents(let profileId):
            return "/user/customer/profiles/\(profileId)/timeline-events"
        case .healthPrompts(let profileId):
            return "/user/customer/profiles/\(profileId)/health-prompts"
        case let .custom(customPath, _):
            return customPath
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .profiles:
            return .get
        case .timelineEvents:
            return .get
        case .healthPrompts:
            return .get
        case let .custom(_, method):
            return method
        }
    }
    
    func getURL(urlParameters: HTTPParameters? = nil) -> URL {
        
        guard var urlComponents = URLComponents(url: Self.baseURL, resolvingAgainstBaseURL: false) else {
            fatalError(CCError.unableToObtainObject.localizedDescription)
        }
        
        switch self {
        case let .custom(url, _):
            return URL(string: url)!
        default:
            urlComponents.path += path
        }
        
        guard let url = urlComponents.url else {
            fatalError(CCError.unableToObtainObject.localizedDescription)
        }
        return url
    }
}
