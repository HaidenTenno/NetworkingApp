//
//  MainViewController.swift
//  templateApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

class MainViewController: UIViewController {
    
    // UI
    private var tempLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    
    // Services
    private let networkService: NetworkService = NetworkServiceImplementation.shared
    private let locationManager = CLLocationManager()
    
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
private extension MainViewController {
    
    private func requestLocation() {
        activityIndicator.startAnimating()
        locationManager.requestLocation()
    }
    
    private func loadData(forName name: String) {
        activityIndicator.startAnimating()
        
        networkService.load(service: CharacterProvider.CurrentWeather.byCityName(name: name), decodeType: CurrentWeather.self) { [weak self] (result) in
            switch result {
            case .success(let weather):
                self?.onDataLoaded(currentWeather: weather)
            case .failure(let error):
                self?.onErrorReceived(error: error)
            }
        }
    }
    
    private func loadData(forLatitude latitude: Double, longitude: Double) {
        networkService.load(service: CharacterProvider.CurrentWeather.byCoordinates(lat: latitude, lon: longitude), decodeType: CurrentWeather.self) { [weak self] (result) in
            switch result {
            case .success(let weather):
                self?.onDataLoaded(currentWeather: weather)
            case .failure(let error):
                self?.onErrorReceived(error: error)
            }
        }
    }
    
    private func onDataLoaded(currentWeather: CurrentWeather) {
        DispatchQueue.main.async { [weak self] in
            self?.tempLabel.text = String(describing: currentWeather.main.temp)
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func onErrorReceived(error: NetworkServiceError) {
        DispatchQueue.main.async { [weak self] in
            switch error {
            case .notFound:
                self?.tempLabel.text = "Not found"
            default:
                self?.tempLabel.text = "Error"
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func onLocationError() {
        tempLabel.text = "Location Error"
        activityIndicator.stopAnimating()
    }
}

// MARK: - UI
private extension MainViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = Design.Colors.redColor
        
        // tempLabel
        tempLabel = UILabel()
        tempLabel.font = Design.Fonts.RegularText.font
        tempLabel.textColor = Design.Fonts.RegularText.color
        view.addSubview(tempLabel)
        
        // activityIndicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        // tempLabel
        tempLabel.snp.makeConstraints { (make) in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        // activityIndicator
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .denied else {
            onLocationError()
            return
        }
        requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        activityIndicator.stopAnimating()
        guard let location = locations.first else { return }
//        print(location.coordinate.latitude, location.coordinate.longitude)
        loadData(forLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        activityIndicator.stopAnimating()
//        print(error)
        onLocationError()
    }
}
