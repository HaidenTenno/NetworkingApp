//
//  ForecastWeatherViewController.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 30.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import UIKit

class ForecastWeatherViewController: UIViewController {

    // UI
    
    // Services
    
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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Sign delegates for sevices
    }
}

// MARK: - Private
private extension ForecastWeatherViewController {
    
}

// MARK: - UI
private extension ForecastWeatherViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = Design.Colors.green
        
        // Configure other elements
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        // Layout elements
    }
}

// MARK: - Other extensions

