//
//  StatTableViewCell.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/6/21.
//

import Foundation
import UIKit

final class StatTableViewCell: UITableViewCell {

    /// Private K constants used in cell
    private struct K {
        static let SATMaxScore: CGFloat = 800.0
    }

    @IBOutlet private weak var statNameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var scoreProgressView: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        statNameLabel.textAlignment = .center
        statNameLabel.textColor = .darkGray
        statNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.systemFont(ofSize: 64, weight: .semibold)

        /// Updates scoreProgressView to a thicker line
        scoreProgressView.transform = CGAffineTransform(scaleX: 1, y: 3)
    }

    /// Basic cell setup with SATScoreType and ResultsViewModel
    /// Calculates progress from score / total SAT score (800)
    func setup(
        type: SATScoreType,
        viewModel: ResultsViewModel
    ) {
        var score = 0

        switch type {
        case .reading:
            statNameLabel.text = viewModel.readingTitle
            score = viewModel.readingScore
            scoreProgressView.tintColor = viewModel.readingScoreColor
        case .math:
            statNameLabel.text = viewModel.mathTitle
            score = viewModel.mathScore
            scoreProgressView.tintColor = viewModel.mathScoreColor
        case .writing:
            statNameLabel.text = viewModel.writingTitle
            score = viewModel.writingScore
            scoreProgressView.tintColor = viewModel.writingScoreColor
        }
        scoreLabel.text = "\(score)"
        scoreProgressView.progress = Float(CGFloat(score) / K.SATMaxScore)
    }
}
