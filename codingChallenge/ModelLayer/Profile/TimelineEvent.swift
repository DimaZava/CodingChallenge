//
//  TimelineEvent.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import Foundation

struct TimelineEvent: Codable {
    
    // MARK: Static members
    static private let timestampDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    // MARK: Constants
    let uuid: String
    let timestamp: String
    let displayCategory: String
    let title: String
    let description: String
    let category: String
    
    // MARK: Computables
    var convertedTimestamp: Date? {
        Self.timestampDateFormatter.date(from: timestamp)
    }
}
