//
//  ViewsCoordinator.swift
//  templateApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import UIKit

final class ViewsCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        presentTabBarController()
    }
}

// MARK: - Private
private extension ViewsCoordinator {
    
    // MARK: - Creators
    private func createCurrentWeatherVC() -> CurrentWeatherViewController {
        let currentWeatherVC = CurrentWeatherViewController()
        
        let tabBarItem = UITabBarItem()
        tabBarItem.image = UIImage(systemName: Design.Images.sun)?
        .withRenderingMode(.automatic)
        currentWeatherVC.tabBarItem = tabBarItem
        
        return currentWeatherVC
    }
    
    private func createForecastWeatherVC() -> ForecastWeatherViewController {
        let forecastWeatherVC = ForecastWeatherViewController()
        
        let tabBarItem = UITabBarItem()
        tabBarItem.image = UIImage(systemName: Design.Images.calendar)?
        .withRenderingMode(.automatic)
        forecastWeatherVC.tabBarItem = tabBarItem
        
        return forecastWeatherVC
    }
    
    // MARK: - Presetners
    
    private func presentTabBarController() {
        let currentWeatherVC = createCurrentWeatherVC()
        let forecastWeatherVC = createForecastWeatherVC()
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [currentWeatherVC, forecastWeatherVC]
        tabBarController.selectedViewController = currentWeatherVC
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func presentCurrentWeatherScreen() {
        let currentWeatherVC = createCurrentWeatherVC()
        navigationController.pushViewController(currentWeatherVC, animated: true)
    }
    
    private func presentForecastWeatherScreen() {
        let forecastWeatherVC = createForecastWeatherVC()
        navigationController.pushViewController(forecastWeatherVC, animated: true)
    }
}
