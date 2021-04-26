//
//  HealthPrompt.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import UIKit

struct HealthPrompt: Codable {
    
    // MARK: Constants
    let uuid: String
    let message: String
    let permanent: Bool // I'd prefer using "isPermanent" name, but it's not worth breaking default decoding strategy
    let displayCategory: String
    let metadata: Metadata
    let style: Style?
}

extension HealthPrompt {
    
    // MARK: - Metadata
    struct Metadata: Codable {
    
        // MARK: - Link
        struct Link: Codable {
            let title: String
            let url: String
        }
        
        let link: Link
    }
    
    // MARK: - Style
    struct Style: Codable {
        
        let primaryColor: String
        let secondaryColor: String
        let image: String // The same as above, would rather prefer "imageURL" name
        
        // MARK: Computables
        var primaryConvertedColor: UIColor? {
            UIColor(hex: primaryColor)
        }
        var secondaryConvertedColor: UIColor? {
            UIColor(hex: secondaryColor)
        }
    }
}
