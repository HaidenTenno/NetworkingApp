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
        presentScreen()
    }
}

// MARK: - Private
private extension ViewsCoordinator {
    
    // MARK: - Creators
    private func createMainVC() -> MainViewController {
        let mainVC = MainViewController()
        return mainVC
    }
    
    // MARK: - Presetners
    private func presentScreen() {
        let mainVC = createMainVC()
        navigationController.pushViewController(mainVC, animated: true)
    }
}
