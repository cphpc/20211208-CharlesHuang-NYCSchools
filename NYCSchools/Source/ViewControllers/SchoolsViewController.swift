//
//  SchoolsViewController.swift
//  NYCSchools
//
//  Created by Charles Huang on 12/4/21.
//

import MapKit
import UIKit

final class SchoolsViewController: UIViewController {

    /// Private K constants used in controller
    private struct K {
        static let navigationTitle: String = "NYC Schools"
        static let listCellId: String = "ListCellId"
        static let errorMessage: String =
            "An error occured. Please check your internet connection and then restart the app. If the error still persists, please try again at a later time."
        static let sheetTitle: String = "Sort NYC school cities by:"
        static let sheetMessage: String = "Default is alphabetically A -> Z"
        static let NYCCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: 40.7128,
            longitude: -74.0060
        )
        static let mapZoom: CLLocationDistance = 100000
    }

    /// Main view model for controller
    private var viewModel = SchoolsViewModel()

    @IBOutlet private weak var listTableView: UITableView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    /// sortBarItem variable is required for placing location of alert controller on iPad
    private lazy var sortBarItem: UIBarButtonItem = {
        return UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down.circle"),
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )
    }()

    /// Handles state transition and animation of controller
    private var state: LoadingState = .loading {
        didSet {
            updateState()
        }
    }

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupSegmentedControl()
        setupTableView()
        setupMapView()

        fetchData()
    }

    /// Updates loading indicator animation and controller state changes
    private func updateState() {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .failed:
            loadingIndicator.stopAnimating()
        }
    }

    /// Basic setup for navigation
    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true

        title = K.navigationTitle
        navigationItem.rightBarButtonItem = sortBarItem
    }

    /// Basic setup for segmented control
    private func setupSegmentedControl() {
        segmentedControl.addTarget(
            self,
            action: #selector(segmentAction(_:)),
            for: .valueChanged
        )
        segmentedControl.selectedSegmentIndex = SchoolListViewType.list.rawValue
    }

    /// Basic setup for table view
    private func setupTableView() {
        listTableView.isHidden = false
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(
            UINib(nibName: "ListTableViewCell", bundle: nil),
            forCellReuseIdentifier: K.listCellId
        )
        listTableView.separatorColor = .systemBlue
        loadingIndicator.hidesWhenStopped = true
    }

    /// Basic setup for map view
    private func setupMapView() {
        mapView.isHidden = true
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsScale = true
        mapView.delegate = self

        let region = MKCoordinateRegion(
            center: K.NYCCoordinates,
            latitudinalMeters: K.mapZoom,
            longitudinalMeters: K.mapZoom
        )
        mapView.setRegion(region, animated: true)

        if !viewModel.schoolLocations.isEmpty {
            mapSchoolLocations()
        }
    }

    // MARK: Controller Methods

    /// Invokes view model to fetch data from SchoolService
    /// When data is successfully retrieved, table view and map views are reloaded
    /// If there is an error, controller will show an error alert
    private func fetchData() {
        guard viewModel.schools.keys.isEmpty else {
            return
        }
        state = .loading

        viewModel.fetchData(completion: { [weak self] result in
            guard let self = self else { return }
            self.state = .loaded

            switch result {
            case .success:
                self.listTableView.reloadData()
                self.mapSchoolLocations()
            case .failure:
                self.showErrorAlert()
            }
        })
    }

    /// Show error alert
    private func showErrorAlert() {
        // create the alert
        let alert = UIAlertController(
            title: "Error",
            message: K.errorMessage,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil
            )
        )
        self.present(alert, animated: true, completion: nil)
    }

    /// Map school locations with annotations for each school
    private func mapSchoolLocations() {
        for (key, value) in viewModel.schoolLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = value
            annotation.title = key
            mapView.addAnnotation(annotation)
        }
    }

    /// Push to ResultsViewController with SATResults
    private func pushToResults(results: SATResults) {
        guard
            let resultsController =
                Bundle.main.loadNibNamed(
                    "ResultsViewController",
                    owner: self,
                    options: nil
                )![0] as? ResultsViewController
        else {
            return
        }
        resultsController.setup(with: ResultsViewModel(with: results))
        navigationController?.pushViewController(resultsController, animated: true)
    }

    /// Show action sheet with associated actions for sorting
    private func showActionSheet() {
        let alphabeticallyAZ = UIAlertAction(
            title: "A -> Z",
            style: .default
        ) { [weak self] action in
            guard let self = self else { return }
            self.viewModel.sortData(state: .AZ)
            self.listTableView.reloadData()
        }

        let alphabeticallyZA = UIAlertAction(
            title: "Z -> A",
            style: .default
        ) { [weak self] action in
            guard let self = self else { return }
            self.viewModel.sortData(state: .ZA)
            self.listTableView.reloadData()
        }

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )

        let alert = UIAlertController(
            title: K.sheetTitle,
            message: K.sheetMessage,
            preferredStyle: .actionSheet
        )
        alert.addAction(alphabeticallyAZ)
        alert.addAction(alphabeticallyZA)
        alert.addAction(cancelAction)

        /// On iPad, action sheets must be presented from a popover
        alert.popoverPresentationController?.barButtonItem = sortBarItem

        present(alert, animated: true)
    }

    // MARK: Action Methods

    /// Handler for when user switches segments
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case SchoolListViewType.list.rawValue:
            listTableView.isHidden = false
            mapView.isHidden = true
        case SchoolListViewType.map.rawValue:
            listTableView.isHidden = true
            mapView.isHidden = false
        default:
            break
        }
    }

    /// Handler for when user clicks on sortBarItem
    @objc func sortTapped() {
        showActionSheet()
    }
}

// MARK: UITableViewDelegate methods

extension SchoolsViewController: UITableViewDataSource {

    /// Number of sections correlates to number of cities
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.schools.keys.count
    }

    /// Number of indices per section correlates to number of schools in each city
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let city = viewModel.citySectionMap[section],
            let schoolsInCity = viewModel.schools[city]
        else {
            return 0
        }
        return schoolsInCity.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    /// Each header title is associated with a city name
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.citySectionMap[section]?.uppercased()
    }

    func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .systemBlue
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = listTableView.dequeueReusableCell(
                withIdentifier: K.listCellId,
                for: indexPath
            ) as? ListTableViewCell, let city = viewModel.citySectionMap[indexPath.section],
            let schoolsInCity = viewModel.schools[city]
        else {
            return UITableViewCell()
        }
        cell.setup(school: schoolsInCity[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listTableView.deselectRow(at: indexPath, animated: true)

        guard let city = viewModel.citySectionMap[indexPath.section],
            let schoolsInCity = viewModel.schools[city],
            let results = schoolsInCity[indexPath.row].SATResults
        else {
            return
        }
        pushToResults(results: results)
    }
}

extension SchoolsViewController: UITableViewDelegate {}

// MARK: MKMapViewDelegate methods

extension SchoolsViewController: MKMapViewDelegate {

    /// When a pin is clicked on, push to ResultsViewController
    func mapView(_ mapView: MKMapView, didSelect: MKAnnotationView) {
        guard let title = didSelect.annotation?.title, let name = title,
            let results = viewModel.schoolResults[name]
        else {
            return
        }
        pushToResults(results: results)
    }
}
