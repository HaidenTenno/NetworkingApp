//
//  CurrentWeatherTableViewManager.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 30.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import Foundation

import UIKit

final class CurrentWeatherTableViewManager: NSObject {
    
    // ViewModel
    private let viewModel: CurrentWeatherViewModel
    
    init(viewModel: CurrentWeatherViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - Table view protocols
extension CurrentWeatherTableViewManager: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        
        if let cell = cell as? ConfigurableCell {
            cell.configure(viewModel: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
