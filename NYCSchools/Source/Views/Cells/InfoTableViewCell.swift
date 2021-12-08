//
//  InfoTableViewCell.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/5/21.
//

import Foundation
import UIKit

final class InfoTableViewCell: UITableViewCell {

    /// Private K constants used in cell
    private struct K {
        static let takerTitle: String = "Total SAT Test Takers"
    }

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var takerLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)

        takerLabel.text = K.takerTitle
        takerLabel.textAlignment = .center
        takerLabel.textColor = .darkGray
        takerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        numberLabel.textAlignment = .center
        numberLabel.textColor = .lightGray
        numberLabel.font = UIFont.systemFont(ofSize: 48, weight: .semibold)
    }

    /// Basic cell setup with ResultsViewModel for basic information
    func setup(viewModel: ResultsViewModel) {
        nameLabel.text = viewModel.name
        numberLabel.text = viewModel.results.numOfSatTestTakers
    }
}
