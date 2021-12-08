//
//  SATResults.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/4/21.
//

import Foundation

struct SATResults: Codable {
    let dbn: String
    let schoolName: String
    let numOfSatTestTakers: String
    let satCriticalReadingAvgScore: String
    let satMathAvgScore: String
    let satWritingAvgScore: String

    init(dbn: String) {
        self.dbn = dbn
        schoolName = ""
        numOfSatTestTakers = "0"
        satCriticalReadingAvgScore = "0"
        satMathAvgScore = "0"
        satWritingAvgScore = "0"
    }

    init(
        dbn: String,
        schoolName: String,
        takers: String,
        readingScore: String,
        mathScore: String,
        writingScore: String
    ) {
        self.dbn = dbn
        self.schoolName = schoolName
        numOfSatTestTakers = takers
        satCriticalReadingAvgScore = readingScore
        satMathAvgScore = mathScore
        satWritingAvgScore = writingScore
    }
}
