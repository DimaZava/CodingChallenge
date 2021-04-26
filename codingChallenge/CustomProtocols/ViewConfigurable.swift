//
//  ViewConfigurable.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import Foundation

protocol ViewConfigurable {
    associatedtype ConfiguringObject
    
    func configure(with object: ConfiguringObject)
}
