//
//  DetailsScreenDetailsScreenViewController.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 27/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

import UIKit

class DetailsScreenViewController: UIViewController {
    
    // You can add here following (in next order, from up to down):
    // typealiases, static members, inner enums, overrided variables, outlets, constants, variables

    // MARK: - Static members
    // MARK: - Enums
    // MARK: - Overrides
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Constants

    // MARK: - Properties
    var output: DetailsScreenViewOutput!
    private let timelineEvent: TimelineEvent
    
    // MARK: - Lifecycle
    init(_ timelineEvent: TimelineEvent) {
        self.timelineEvent = timelineEvent
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.onViewIsReady()
    }

    // MARK: - Actions

    // MARK: - Other (Current Scope)
}

// MARK: - DetailsScreenViewController Private Functions
private extension DetailsScreenViewController {
}

// MARK: - DetailsScreenViewInput
extension DetailsScreenViewController: DetailsScreenViewInput {
    
    func setupInitialState() {
        titleLabel.text = timelineEvent.title
    }

    func onViewWillAppear() {
    }

    func onError(_ error: Error) {
    }
}
