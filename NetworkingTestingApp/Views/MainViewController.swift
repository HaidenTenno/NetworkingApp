//
//  MainViewController.swift
//  templateApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // UI
    private var tempLabel: UILabel!
    
    // Services
    let networkService: NetworkService = NetworkServiceImplementation.shared
    
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
        networkService.load(service: CharacterProvider.CurrentWeather.byCityName(name: "Saint Petersburg"), decodeType: CurrentWeather.self) { [weak self] (result) in
            switch result {
            case .success(let weather):
                self?.onDataLoaded(currentWeather: weather)
            case .failure(let error):
                self?.onErrorReceived(error: error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Private
private extension MainViewController {
    
    private func onDataLoaded(currentWeather: CurrentWeather) {
        DispatchQueue.main.async { [weak self] in
            self?.tempLabel.text = String(describing: currentWeather.main.temp)
        }
    }
    
    private func onErrorReceived(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.tempLabel.text = "Error"
            print(error)
        }
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
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        // tempLabel
        tempLabel.snp.makeConstraints { (make) in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
