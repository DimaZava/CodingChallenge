//
//  Profile.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import UIKit

struct Profile: Codable {
    
    // MARK: Static members
    static private let dateOfBirthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static private let applicationDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    // MARK: Constants
    let profileId: String
    let firstName: String
    let lastName: String
    let gender: Gender
    let displayName: String
    let isPrimaryProfile: Bool
    let policyNumber: String
    let tariffId: String
    let tariffLabel: String
    let tariff: Tariff
    let dateOfBirth: String
    let applicationDate: String
    let address: Address
    let contact: Contact
    let profileAttributes: [String]
    
    // MARK: Computables
    var convertedDateOfBirth: Date? {
        Self.dateOfBirthFormatter.date(from: dateOfBirth)
    }
    var convertedApplicationDate: Date? {
        Self.applicationDateFormatter.date(from: applicationDate)
    }
}

// MARK: - Subtypes
extension Profile {
    
    // MARK: - Gender
    enum Gender: String, Codable {
        case male
        case female
    }
    
    // MARK: - Tariff
    struct Tariff: Codable {
        
        // MARK: - Icon
        struct Icon: Codable {
            
            // MARK: Constants
            let url: String
            let secondaryUrl: String
            let primaryColor: String
            let secondaryColor: String
            
            // MARK: Computables
            var primaryConvertedColor: UIColor? {
                UIColor(hex: primaryColor)
            }
            var secondaryConvertedColor: UIColor? {
                UIColor(hex: secondaryColor)
            }
        }
        
        let id: String
        let label: String
        let icon: Icon
        let excessRate: Int
    }
    
    // MARK: - Address
    struct Address: Codable {
        let street: String
        let streetNumber: String
        let zip: String
        let city: String
        let additional: String
    }
    
    // MARK: - Contact
    struct Contact: Codable {
        let email: String
        let phone: String
    }
}
