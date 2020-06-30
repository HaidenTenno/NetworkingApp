//
//  ConfigurableCell.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 30.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import UIKit

protocol ConfigurableCell: UITableViewCell {
    func configure(viewModel: ViewModelItem)
}

protocol SelectableCell: ConfigurableCell {
    var onSelect: (() -> Void)? { get set }
}
