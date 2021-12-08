//
//  NYCSchoolsResultsViewModelTests.swift
//  NYCSchoolsTests
//
//  Created by Charles Huang on 12/7/21.
//

import XCTest

@testable import NYCSchools

/// Basic ResultsViewModel tests to make sure results view is showing correct data
class NYCSchoolsResultsViewModelTests: BaseTestCase {
    var viewModel: ResultsViewModel!

    func testResultsViewModel1() throws {
        let results = SATResults(
            dbn: "01M292",
            schoolName: "UNIVERSITY NEIGHBORHOOD HIGH SCHOOL",
            takers: "91",
            readingScore: "383",
            mathScore: "423",
            writingScore: "370"
        )
        viewModel = ResultsViewModel(with: results)

        XCTAssertEqual(viewModel.name, "University Neighborhood High School")
        XCTAssertEqual(viewModel.readingScore, 383)
        XCTAssertEqual(viewModel.mathScore, 423)
        XCTAssertEqual(viewModel.writingScore, 370)
    }

    func testResultsViewModel2() throws {
        let results = SATResults(
            dbn: "01M458",
            schoolName: "FORSYTH SATELLITE ACADEMY",
            takers: "7",
            readingScore: "414",
            mathScore: "401",
            writingScore: "359"
        )
        viewModel = ResultsViewModel(with: results)

        XCTAssertEqual(viewModel.name, "Forsyth Satellite Academy")
        XCTAssertEqual(viewModel.readingScore, 414)
        XCTAssertEqual(viewModel.mathScore, 401)
        XCTAssertEqual(viewModel.writingScore, 359)
    }

    func testResultsViewModel3() throws {
        let results = SATResults(
            dbn: "01M515",
            schoolName: "LOWER EAST SIDE PREPARATORY HIGH SCHOOL",
            takers: "112",
            readingScore: "332",
            mathScore: "557",
            writingScore: "316"
        )
        viewModel = ResultsViewModel(with: results)

        XCTAssertEqual(viewModel.name, "Lower East Side Preparatory High School")
        XCTAssertEqual(viewModel.readingScore, 332)
        XCTAssertEqual(viewModel.mathScore, 557)
        XCTAssertEqual(viewModel.writingScore, 316)
    }
}
