//
//  PlistParser.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import Foundation

class PlistParser {
    
    public static var apiKey: String {
        guard let result = getStringValue(for: Config.KeysPlist.apiKey) else { fatalError() }
        return result
    }
    
    public static func getStringValue(for key: String) -> String? {
        guard let path = Bundle.main.path(forResource: Config.KeysPlist.fileName, ofType: "plist") else { return nil }
        guard let dictionary = NSDictionary(contentsOfFile: path) else { return nil }
        guard let result = dictionary[key] as? String else { return nil }
        return result
    }
}
