//
//  SchoolsViewModel.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/4/21.
//

import Combine
import Foundation
import MapKit

final class SchoolsViewModel {

    /// Private K constants used in view model
    private struct K {
        static let schoolId: String = "schools-id"
        static let noSATId: String = "s"
    }

    /// Published school dictionary
    /// Key: city name
    /// Value: array of School objects
    /// This data is saved to UserDefaults after initial fetch
    /// This cache allows us to load the app extremely quickly
    @Published var schools = [String: [School]]()

    private var schoolService = SchoolService()
    /// Default sort for cities is A->Z
    private var currentSortState: SchoolListSortState = .AZ
    private var cancellable: AnyCancellable?

    // schoolLocations dictionary is used for map view locations
    var schoolLocations = [String: CLLocationCoordinate2D]()
    // schoolResults is used for O(1) school name-result lookup
    var schoolResults = [String: SATResults]()
    // citySecitonMap is used for mapping city-school sections dynamically
    var citySectionMap = [Int: String]()

    /// Initializer will try to load data from UserDefault
    /// If data exists, calculate city sections and school information
    init() {
        loadData()

        if !schools.keys.isEmpty {
            calculateCitySections()
            calculateSchoolInformation()
        }
    }

    // MARK: Private Methods

    /// Method to encode and save data to UserDefaults
    private func saveData() {
        UserDefaults.standard.set(try? JSONEncoder().encode(schools), forKey: K.schoolId)
    }

    /// Method to decode data from UserDefaults
    private func loadData() {
        if let schoolData = UserDefaults.standard.data(forKey: K.schoolId),
            let schools = try? JSONDecoder().decode([String: [School]].self, from: schoolData)
        {
            self.schools = schools
        }
    }

    /// Format school data so that it is represented in a dictionary
    /// The dictionary has keys correlating to cities and values of each school within the city
    /// This allows the view model to tell the controller the number of sections (cities)
    /// as well as the schools within each city (indices)
    /// Note, in the main schools dictionary, only the schools with valid SAT results are kept
    private func formatSchoolData(schools: [School], results: [SATResults]) -> [String: [School]] {
        var schoolsWithSAT = [School]()
        var formattedData = [String: [School]]()

        for result in results {
            guard result.numOfSatTestTakers != K.noSATId else {
                continue
            }
            if var school = schools.first(where: { $0.dbn == result.dbn }) {
                school.updateSATResults(results: result)
                schoolsWithSAT.append(school)
            }
        }

        schoolsWithSAT.forEach { school in
            if var list = formattedData[school.city] {
                list.append(school)
                list.sort {
                    $0.schoolName < $1.schoolName
                }
                formattedData[school.city] = list
            } else {
                formattedData[school.city] = [school]
            }
        }

        return formattedData
    }

    /// This method dynamically recalculates city-school mapping
    private func calculateCitySections() {
        citySectionMap.removeAll()

        var cities = Array(schools.keys)
        switch currentSortState {
        case .AZ:
            cities.sort { $0 < $1 }
        case .ZA:
            cities.sort { $0 > $1 }
        }

        for (index, city) in cities.enumerated() {
            citySectionMap[index] = city
        }
    }

    /// This method dynamically calculates the schools location information
    /// schoolResults also maps the school's SAT results so looking up results is O(1)
    /// Data here is mainly used in the controller's map view
    private func calculateSchoolInformation() {
        Array(schools.values).joined().forEach { school in
            if let lat = school.latitude, let latDegrees = Double(lat),
                let long = school.longitude, let longDegrees = Double(long)
            {
                let coordinates = CLLocationCoordinate2D(
                    latitude: latDegrees,
                    longitude: longDegrees
                )
                schoolLocations[school.schoolName] = coordinates
                schoolResults[school.schoolName] = school.SATResults
            }
        }
    }

    // MARK: Public Methods

    /// Fetches data with SchoolService class
    /// Checks if schools or results is empty when value received
    /// If empty, a .failure is returned
    /// If data is non-empty, sort and format the data
    /// then a success is returned
    func fetchData(completion: @escaping (VoidResult) -> Void) {
        cancellable = Publishers.Zip(
            schoolService.fetchAllSchools(),
            schoolService.fetchAllSATResults()
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished:
                    self.sortData(state: .AZ)
                    self.saveData()
                    completion(.success)
                case .failure:
                    completion(.failure)
                }
            },
            receiveValue: { [weak self] schools, results in
                guard let self = self, !schools.isEmpty, !results.isEmpty else {
                    completion(.failure)
                    return
                }
                self.schools = self.formatSchoolData(schools: schools, results: results)
                self.calculateCitySections()
                self.calculateSchoolInformation()
            }
        )
    }

    /// Method called to sort cities by SchoolListSortState
    /// A->Z: Alphabetically
    /// Z->A: Reverse alphabetically
    func sortData(state: SchoolListSortState) {
        guard currentSortState != state else {
            return
        }
        currentSortState = state
        calculateCitySections()
    }
}
