//
//  HomeScreenEventsSectionHeader.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26.04.2021.
//

import UIKit

class HomeScreenEventsSectionHeader: UITableViewHeaderFooterView, ViewConfigurable {
    typealias ConfiguringObject = Date
    
    static let desiredHeaderHeight: CGFloat = labelHeight + labelTopInset + labelBottomInset
    
    static private let labelHeight: CGFloat = 32
    static private let labelTopInset: CGFloat = 16
    static private let labelBottomInset: CGFloat = 8
    
    // MARK: Static members
    static private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var labelTopInsetConstraint: NSLayoutConstraint!
    @IBOutlet private weak var labelBottomInsetConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        let clearView = UIView()
        clearView.backgroundColor = .clear
        backgroundView = clearView
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = Colors.HomeScreen.TableViewSectionHeader.titleColor
        labelHeightConstraint.constant = Self.labelHeight
        labelTopInsetConstraint.constant = Self.labelTopInset
        labelBottomInsetConstraint.constant = Self.labelBottomInset
    }
    
    func configure(with object: Date) {
        titleLabel.text = Self.dateFormatter.string(from: object)
    }
}
