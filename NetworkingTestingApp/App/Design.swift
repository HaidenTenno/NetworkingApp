//
//  Design.swift
//  templateApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import UIKit

enum Design {
    
    enum Colors {
        static let red = UIColor.systemRed
        static let green = UIColor.systemGreen
    }
    
    enum Fonts {
        enum RegularText {
            static let font = UIFont.systemFont(ofSize: 20)
            static let color = UIColor.black
        }
    }
    
    enum Images {
        static let sun = "sun.max.fill"
        static let calendar = "calendar"
    }
}

