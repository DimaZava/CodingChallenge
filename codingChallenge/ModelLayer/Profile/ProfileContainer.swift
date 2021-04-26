//
//  ProfileContainer.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import Foundation

struct ProfileContainer {
    
    struct OrderedTimelineEvents {
        let dateComponents: DateComponents
        let events: [TimelineEvent]
    }
    
    let profile: Profile
    let timelineEvents: [TimelineEvent]
    let healthPrompts: [HealthPrompt]
    
    var timelineEventsOrdered: [OrderedTimelineEvents] {
        do {
            let dict = try Dictionary(grouping: timelineEvents) { event -> DateComponents in
                guard let dateTimestamp = event.convertedTimestamp else { throw CCError.unableToObtainObject }
                return Calendar.current.dateComponents([.day, .year, .month], from: dateTimestamp)
            }
            return dict.map { .init(dateComponents: $0.key, events: $0.value) }
        } catch {
            print(error)
            return .init()
        }
    }
}
