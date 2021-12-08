//
//  SchoolService.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/4/21.
//

import Combine
import Foundation

/// SchoolService is a class with the main purpose of fetching data
/// The service uses the Combine library to fetch and publish the response
final class SchoolService {

    /// private K constants used in service
    private struct K {
        static let scheme: String = "https"
        static let host: String = "data.cityofnewyork.us"
        static let schoolsPath: String = "/resource/s3k6-pzi2.json"
        static let resultsPath: String = "/resource/f9bf-2cp4.json"
    }

    private var components = URLComponents()
    private var decoder = JSONDecoder()
    var cancellables = Set<AnyCancellable>()

    init() {
        components.scheme = K.scheme
        components.host = K.host

        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    /// Fetches information for all high schools within NYC
    /// The response is an array of School objects
    /// If there is an error, an empty array is returned
    func fetchAllSchools() -> AnyPublisher<[School], Never> {
        components.path = K.schoolsPath

        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map {
                $0.data
            }
            .decode(type: [School].self, decoder: decoder)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }

    /// Fetches SAT results for all applicable high schools within NYC
    /// The response is an array of SATResults objects
    /// If there is an error, an empty array is returned
    func fetchAllSATResults() -> AnyPublisher<[SATResults], Never> {
        components.path = K.resultsPath

        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map {
                $0.data
            }
            .decode(type: [SATResults].self, decoder: decoder)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }

    /// Fetches SAT results for a single high school with the specific dbn
    /// The response is a SATResults object
    /// If there is an error, an empty SATResults object is returned
    /// - Parameters:
    ///   - dbn: the unique dbn of a high school within NYC
    func fetchSATResultsForSchool(with dbn: String) -> AnyPublisher<SATResults, Never> {
        components.path = K.resultsPath
        components.queryItems = [URLQueryItem(name: "dbn", value: dbn)]

        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map {
                $0.data
            }
            .decode(type: SATResults.self, decoder: decoder)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: SATResults(dbn: dbn))
            .eraseToAnyPublisher()
    }
}
