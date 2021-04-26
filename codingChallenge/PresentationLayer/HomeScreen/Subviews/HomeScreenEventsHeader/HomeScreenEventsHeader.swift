//
//  HomeScreenEventsHeader.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import UIKit

class HomeScreenEventsHeader: UIView, ViewConfigurable {
    typealias ConfiguringObject = HealthPrompt
    
    // MARK: Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var actionButton: UIButton!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.backgroundColor = Colors.HomeScreen.TableViewHeader.fillColor
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.cornerCurve = .continuous
        
        contentLabel.font = .preferredFont(forTextStyle: .headline)
        
        actionButton.tintColor = .white
        actionButton.backgroundColor = Colors.HomeScreen.TableViewHeader.mainButtonFillColor
        actionButton.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        actionButton.layer.masksToBounds = true
        actionButton.layer.cornerRadius = 10
        actionButton.layer.cornerCurve = .continuous
        
        closeButton.tintColor = Colors.HomeScreen.TableViewHeader.closeButtonColor
    }
    
    func configure(with object: HealthPrompt) {
        contentLabel.text = object.message
    }
}
