//
//  ResultsViewModel.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/5/21.
//

import Foundation
import UIKit

struct ResultsViewModel {

    /// Private K constants used in view model
    private struct K {
        static let readingTitle: String = "Critical Reading Score"
        static let mathTitle: String = "Math Score"
        static let writingTitle: String = "Writing Score"
    }

    /// Dynamic variable for school name capitalized
    /// The json returns school name in all caps
    var name: String {
        results.schoolName.capitalized
    }

    /// Dynamic variables below are all used within the UI

    var readingTitle: String {
        K.readingTitle
    }

    var readingScore: Int {
        Int(results.satCriticalReadingAvgScore) ?? 0
    }

    var readingScoreColor: UIColor {
        .systemRed
    }

    var mathTitle: String {
        K.mathTitle
    }

    var mathScore: Int {
        Int(results.satMathAvgScore) ?? 0
    }

    var mathScoreColor: UIColor {
        .systemIndigo
    }

    var writingTitle: String {
        K.writingTitle
    }

    var writingScore: Int {
        Int(results.satWritingAvgScore) ?? 0
    }

    var writingScoreColor: UIColor {
        .systemCyan
    }

    let results: SATResults

    /// Initialize ResultsViewController with SATResults
    init(with results: SATResults) {
        self.results = results
    }
}
