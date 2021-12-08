//
//  NYCSchoolsSchoolsViewModelTests.swift
//  NYCSchoolsTests
//
//  Created by Charles Huang on 12/7/21.
//

import MapKit
import XCTest

@testable import NYCSchools

/// Testing SchoolsViewModel is a little bit more difficult as it involves decoding json data
class NYCSchoolsSchoolsViewModelTests: BaseTestCase {
    private struct K {
        static let schoolFile: String = "schools"
        static let schoolId: String = "schools-id"
    }

    var decoder: JSONDecoder = JSONDecoder()
    var viewModel: SchoolsViewModel!

    override func tearDown() {
        super.tearDown()

        UserDefaults.standard.removeObject(forKey: K.schoolId)
    }

    override func setUp() {
        super.setUp()

        /// Decode data from JSON file and update schools array
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = data(fromFile: K.schoolFile)
        let decodedSchools = try! decoder.decode([School].self, from: data)

        /// Format school data correctly
        /// Can also add a test for viewModel.formatSchoolData()
        var tmpSchools = [String: [School]]()
        decodedSchools.forEach { school in
            if var schools = tmpSchools[school.city] {
                schools.append(school)
                tmpSchools[school.city] = schools
            } else {
                tmpSchools[school.city] = [school]
            }
        }

        /// Save to UserDefaults
        UserDefaults.standard.set(try? JSONEncoder().encode(tmpSchools), forKey: K.schoolId)

        /// Initialize SchoolsViewModel and read from UserDefaults
        viewModel = SchoolsViewModel()
    }

    /// Load from UserDefaults to make sure data is non-nil
    func testLoadingFromUserDefaults() throws {
        if let schoolData = UserDefaults.standard.data(forKey: K.schoolId),
            let savedData = try? JSONDecoder().decode([String: [School]].self, from: schoolData)
        {
            XCTAssertNotNil(savedData)
        }
    }

    /// Test school keys to make sure correct cities
    func testSchoolsViewModel1() throws {
        let cities = Set(viewModel.schools.keys)
        XCTAssertEqual(cities, Set(["Manhattan", "Brooklyn"]))
    }

    /// Test city sections to make sure sections are mapped
    func testSchoolsViewModel2() throws {
        let sections = Set(viewModel.citySectionMap.keys)
        XCTAssertEqual(sections, Set([0, 1]))

        let cities = Set(viewModel.citySectionMap.values)
        XCTAssertEqual(cities, Set(["Brooklyn", "Manhattan"]))
    }

    /// Test sorting city sections by reverse alphabetical
    func testSchoolsViewModel3() throws {
        viewModel.sortData(state: .ZA)

        XCTAssertEqual(viewModel.citySectionMap[0], "Manhattan")
        XCTAssertEqual(viewModel.citySectionMap[1], "Brooklyn")
    }

    /// Test lat/long coordinates to make sure map view will show correctly
    func testSchoolsViewModel4() throws {
        let savedCoordinates = viewModel.schoolLocations["Marta Valle High School"]
        let coordinates = CLLocationCoordinate2D(
            latitude: 40.72004,
            longitude: -73.986
        )

        XCTAssertEqual(savedCoordinates?.latitude, coordinates.latitude)
        XCTAssertEqual(savedCoordinates?.longitude, coordinates.longitude)
    }
}
