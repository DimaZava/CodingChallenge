//
//  DataService+Profiles.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import Foundation

extension DataService {
    
    /// Get ProfileContainer including exact profiles, time events and health prompts
    /// - Parameter result: Result enum containing ProfileContainer or error.
    func profileInfo(result: @escaping (Result<ProfileContainer, Error>) -> Void) {
        
        apiService.profiles { [weak self] profilesResult in
            
            guard let self = self else { print(CCError.unableToObtainObject.localizedDescription); return }
            
            switch profilesResult {
            case .success(let rawProfiles):
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    // This guard is only for demonstration purposes
                    guard let profile = try jsonDecoder.decode([Profile].self, from: rawProfiles).first else {
                        print(CCError.unableToObtainObject.localizedDescription)
                        return
                    }
                    
                    self.profileFeatures(profile) { featuresResult in
                        switch featuresResult {
                        case .success(let features):
                            result(.success(.init(profile: profile,
                                                  timelineEvents: features.events,
                                                  healthPrompts: features.prompts)))
                        case .failure(let error):
                            result(.failure(error))
                        }
                    }
                } catch {
                    print(error)
                    result(.failure(error))
                }
            case .failure(let error):
                print(error)
                result(.failure(error))
            }
        }
    }
}

private extension DataService {
    
    typealias ProfileFeatures = (events: [TimelineEvent], prompts: [HealthPrompt])
    
    /// Helper function wich uses profile to obtain corresponding profiles features, such as
    /// timeline events and health prompts.
    /// - Parameters:
    ///   - profile: Profile to get features for.
    ///   - result: Result enum containing desired profile features or error.
    func profileFeatures(_ profile: Profile,
                         result: @escaping (Result<ProfileFeatures, Error>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var events: [TimelineEvent]?
        var prompts: [HealthPrompt]?
        
        dispatchGroup.enter()
        apiService.timelineEvents(for: profile.profileId) { obtainedResult in
            switch obtainedResult {
            case .success(let rawEvents):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    events = try decoder.decode([TimelineEvent].self, from: rawEvents)
                } catch {
                    print(error)
                    result(.failure(error))
                }
            case .failure(let error):
                print(error)
                result(.failure(error))
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        apiService.healthPrompts(for: profile.profileId) { obtainedResult in
            switch obtainedResult {
            case .success(let rawEvents):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    prompts = try decoder.decode([HealthPrompt].self, from: rawEvents)
                } catch {
                    print(error)
                    result(.failure(error))
                }
            case .failure(let error):
                print(error)
                result(.failure(error))
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            // We can handle this type of error using this switch after completing requests
            // or ignore it and just fill with default (empty) array
            switch (events, prompts) {
            case let (.some(events), .some(prompts)):
                result(.success((events: events, prompts: prompts)))
            case let (nil, .some(prompts)):
                result(.success((events: .init(), prompts: prompts)))
            case let (.some(events), nil):
                result(.success((events: events, prompts: .init())))
            case (nil, nil):
                result(.success((events: .init(), prompts: .init())))
            }
        }
    }
}
