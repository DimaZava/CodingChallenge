//
//  HomeScreenHomeScreenViewController.swift
//  codingChallenge
//
//  Created by Dmitry Zawadsky on 26/04/2021.
//  Copyright © 2021 Ottonova. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    // You can add here following (in next order, from up to down):
    // typealiases, static members, inner enums, overrided variables, outlets, constants, variables

    // MARK: - Static members
    // MARK: - Enums
    // MARK: - Overrides
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Constants

    // MARK: - Properties
    private var container: ProfileContainer?
    private var timeline = [ProfileContainer.OrderedTimelineEvents]()
    var output: HomeScreenViewOutput!
    
    // MARK: - Lifecycle
    init() {
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

// MARK: - HomeScreenViewController Private Functions
private extension HomeScreenViewController {
}

// MARK: - HomeScreenViewInput
extension HomeScreenViewController: HomeScreenViewInput {
    
    func setupInitialState() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Events"
        
        let tableHeaderView = UINib(nibName: String(describing: HomeScreenEventsHeader.self), bundle: nil)
            .instantiate(withOwner: self, options: nil).first as? HomeScreenEventsHeader
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView?.heightAnchor.constraint(equalToConstant: 160).isActive = true
        tableHeaderView?.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing: HomeScreenEventsSectionHeader.self), bundle: nil),
                           forHeaderFooterViewReuseIdentifier: String(describing: HomeScreenEventsSectionHeader.self))
        tableView.register(UINib(nibName: String(describing: HomeScreenEventsCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: HomeScreenEventsCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }

    func onViewWillAppear() {
        
    }
    
    func onProfileContainerObtained(_ container: ProfileContainer) {
        self.container = container
        timeline = container.timelineEventsOrdered
        tableView.reloadData()
    }

    func onError(_ error: Error) {
        print(error)
    }
}

// MARK: - UITableViewDelegate
extension HomeScreenViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableViewDataSource
extension HomeScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        HomeScreenEventsSectionHeader.desiredHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: String(describing: HomeScreenEventsSectionHeader.self))
        if let date = Calendar.current.date(from: timeline[section].dateComponents) {
            (header as? HomeScreenEventsSectionHeader)?.configure(with: date)
        }
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        timeline.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timeline[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeScreenEventsCell.self),
                                                 for: indexPath)
        (cell as? HomeScreenEventsCell)?.configure(with: timeline[indexPath.section].events[indexPath.row])
        return cell
    }
}
