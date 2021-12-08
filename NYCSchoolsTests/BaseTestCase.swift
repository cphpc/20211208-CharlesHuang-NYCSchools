//
//  BaseTestCase.swift
//  NYCSchoolsTests
//
//  Created by Charles Huang on 12/7/21.
//

import XCTest

class BaseTestCase: XCTestCase {

    // MARK: - Serialization
    func data(fromFile fileName: String) -> Data {
        guard
            let jsonPath = Bundle(for: type(of: self)).path(
                forResource: fileName,
                ofType: "json"
            )
        else {
            XCTFail("Could not find json file named \(fileName)")
            fatalError()
        }

        do {
            let jsonUrl = URL(fileURLWithPath: jsonPath)
            let data = try Data(contentsOf: jsonUrl, options: .mappedIfSafe)

            return data
        } catch {
            XCTFail("Could not parse json file named \(fileName)")
            fatalError()
        }
    }
}
