//
//  CurrentWeatherViewController.swift
//  templateApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    // UI
    private var tableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView!
    
    // Services
    private let networkService: NetworkService = NetworkServiceImplementation.shared
    private let locationManager = CLLocationManager()
    
    // Table Manager
    private var tableManager: CurrentWeatherTableViewManager? {
        didSet {
            guard tableManager != nil else { return }
            setupTableManager()
        }
    }
    
    // View Model
    private var viewModel: CurrentWeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            tableManager = CurrentWeatherTableViewManager(viewModel: viewModel)
        }
    }
    
    // Callbacks
    
    // Public
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - Private
private extension CurrentWeatherViewController {
    
    private func setupTableManager() {
        tableView.delegate = tableManager
        tableView.dataSource = tableManager
        tableView.reloadData()
    }
    
    private func requestLocation() {
        activityIndicator.startAnimating()
        locationManager.requestLocation()
    }
    
    private func loadData(forName name: String) {
        activityIndicator.startAnimating()
        
        // TODO: Change to callback
        networkService.load(service: CharacterProvider.CurrentWeather.byCityName(name: name), decodeType: CurrentWeather.self) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.onDataLoaded(currentWeather: weather)
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                    self?.onErrorReceived(error: error)
                }
            }
        }
    }
    
    private func loadData(forLatitude latitude: Double, longitude: Double) {
        activityIndicator.startAnimating()
        
        networkService.load(service: CharacterProvider.CurrentWeather.byCoordinates(lat: latitude, lon: longitude), decodeType: CurrentWeather.self) { [weak self] (result) in
            switch result {
            case .success(let weather):
                self?.onDataLoaded(currentWeather: weather)
            case .failure(let error):
                #if DEBUG
                print(error)
                #endif
                self?.onErrorReceived(error: error)
            }
        }
    }
    
    // MARK: - Events
    private func onDataLoaded(currentWeather: CurrentWeather) {
        viewModel = CurrentWeatherViewModel(currentWeatherInfo: currentWeather)
        activityIndicator.stopAnimating()
    }
    
    private func onErrorReceived(error: NetworkServiceError) {
        switch error {
        case .notFound:
            print("Not found")
        default:
            print("Network error")
        }
        activityIndicator.stopAnimating()
    }
    
    private func onLocationError() {
        print("Location Error")
        activityIndicator.stopAnimating()
    }
}

// MARK: - UI
private extension CurrentWeatherViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = Design.Colors.red
        
        // tableView
        tableView = UITableView()
        tableView.backgroundColor = Design.Colors.red
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = true
        view.addSubview(tableView)
        // register cells
        tableView.register(CurrentTemperatureTableViewCell.self, forCellReuseIdentifier: Config.IDs.Cells.temperature)
        
        // activityIndicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        // tableView
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // activityIndicator
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension CurrentWeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .denied else {
            onLocationError()
            return
        }
        requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        activityIndicator.stopAnimating()
        guard let location = locations.first else { onLocationError(); return }
        loadData(forLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        activityIndicator.stopAnimating()
        #if DEBUG
        print(error)
        #endif
        onLocationError()
    }
}
