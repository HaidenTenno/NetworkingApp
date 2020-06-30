//
//  CurrentWeatherViewModel.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 30.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import Foundation

// MARK: - Item types
enum CurrentWeatherViewModelItemType {
    // Main section
    case temperature
    static let mainSectionItems: [CurrentWeatherViewModelItemType] = [.temperature]
}

// MARK: - Protocols
protocol CurrentWeatherViewModelSection {
    var items: [CurrentWeatherViewModelItem] { get }
}

protocol CurrentWeatherViewModelItem: ViewModelItem {
    var type: CurrentWeatherViewModelItemType { get }
    var identifier: String { get }
}

// MARK: - Main section
final class CurrentWeatherViewModelMainSection: CurrentWeatherViewModelSection {
    var items: [CurrentWeatherViewModelItem] = []
    
    init(currentWeatherInfo: CurrentWeather) {
        for mainSectionItem in CurrentWeatherViewModelItemType.mainSectionItems {
            switch mainSectionItem {
            case .temperature:
                items.append(CurrentWeatherViewModelTemperatureItem(currentWeatherInfo: currentWeatherInfo))
            default:
                return
            }
        }
    }
}

final class CurrentWeatherViewModelTemperatureItem: CurrentWeatherViewModelItem {
    var type = CurrentWeatherViewModelItemType.temperature
    var identifier = Config.IDs.Cells.temperature
    
    let temperature: String
    
    init(currentWeatherInfo: CurrentWeather) {
        temperature = "\(Int(currentWeatherInfo.main.temp)) °C"
    }
}

// MARK: - CurrentWeatherViewModel
final class CurrentWeatherViewModel {
    
    var sections: [CurrentWeatherViewModelSection] = []
    
    init(currentWeatherInfo: CurrentWeather) {
        // Main section
        let mainSection = CurrentWeatherViewModelMainSection(currentWeatherInfo: currentWeatherInfo)
        sections.append(mainSection)
    }
}
