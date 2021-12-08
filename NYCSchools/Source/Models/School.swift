//
//  School.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/4/21.
//

import Foundation

struct School: Codable {
    /// Dynamic variable for school's general location
    var generalLocation: String {
        "\(neighborhood), \(city) \(zip)"
    }

    /// Dynamic string for schol grade information
    var grades: String {
        "Grades: \(grades2018)"
    }

    let dbn: String
    let schoolName: String
    let city: String
    let zip: String
    let latitude: String?
    let longitude: String?
    let neighborhood: String
    let grades2018: String
    private(set) var SATResults: SATResults?

    /// Mutating func require to update SATResults property on struct
    mutating func updateSATResults(results: SATResults) {
        self.SATResults = results
    }
}
