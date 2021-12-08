//
//  ResultsViewController.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/5/21.
//

import Foundation
import UIKit

final class ResultsViewController: UIViewController {

    /// Private K constants used in controller
    private struct K {
        static let infoCellId: String = "InfoCellId"
        static let statCellId: String = "StatCellId"
    }

    /// Main view model for controller
    var viewModel: ResultsViewModel!
    @IBOutlet weak var resultsTableView: UITableView!

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.register(
            UINib(nibName: "InfoTableViewCell", bundle: nil),
            forCellReuseIdentifier: K.infoCellId
        )
        resultsTableView.register(
            UINib(nibName: "StatTableViewCell", bundle: nil),
            forCellReuseIdentifier: K.statCellId
        )
        resultsTableView.separatorStyle = .none
    }

    /// Basic setup with view model
    func setup(with viewModel: ResultsViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: UITableViewDelegate methods

extension ResultsViewController: UITableViewDataSource {

    /// Number of sections correlates to all cases of ResultsSectionType
    func numberOfSections(in tableView: UITableView) -> Int {
        return ResultsSectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == ResultsSectionType.info.rawValue {
            return 1
        }
        return SATScoreType.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    /// For this table view, there are two sections
    /// School information and SAT results section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == ResultsSectionType.info.rawValue,
            let cell = resultsTableView.dequeueReusableCell(
                withIdentifier: K.infoCellId,
                for: indexPath
            ) as? InfoTableViewCell
        {
            cell.setup(viewModel: viewModel)
            return cell
        } else if indexPath.section == ResultsSectionType.stats.rawValue,
            let cell = resultsTableView.dequeueReusableCell(
                withIdentifier: K.statCellId,
                for: indexPath
            ) as? StatTableViewCell
        {
            cell.setup(
                type: SATScoreType(rawValue: indexPath.row)!,
                viewModel: viewModel
            )
            return cell
        }
        return UITableViewCell()
    }
}

extension ResultsViewController: UITableViewDelegate {}
