//
//  HomeScreenEventsCell.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import UIKit

class HomeScreenEventsCell: UITableViewCell, ViewConfigurable {
    typealias ConfiguringObject = TimelineEvent
    
    @IBOutlet private weak var userpicImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        userpicImageView.backgroundColor = Colors.HomeScreen.TableViewRow.imagePlaceholderColor
        userpicImageView.layer.masksToBounds = true
        userpicImageView.layer.cornerRadius = userpicImageView.frame.height / 2
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = Colors.HomeScreen.TableViewRow.titleColor
        
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = Colors.HomeScreen.TableViewRow.subtitleColor
    }

    func configure(with object: TimelineEvent) {
        titleLabel.text = object.title
        subtitleLabel.text = object.description
    }
}
