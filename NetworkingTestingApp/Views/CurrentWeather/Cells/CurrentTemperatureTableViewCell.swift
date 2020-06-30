//
//  CurrentTemperatureTableViewCell.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 30.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import UIKit

class CurrentTemperatureTableViewCell: UITableViewCell {

    //UI
    private var tempLabel: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        tempLabel.removeFromSuperview()
    }
}

// MARK: - ConfigurableCell
extension CurrentTemperatureTableViewCell: ConfigurableCell {
    
    func configure(viewModel: ViewModelItem) {
        guard let viewModel = viewModel as? CurrentWeatherViewModelTemperatureItem else { return }
        guard viewModel.type == .temperature else { return }
        
        // self
        selectionStyle = .none
        backgroundColor = Design.Colors.red
        
        // tempLabel
        tempLabel = UILabel()
        tempLabel.font = Design.Fonts.RegularText.font
        tempLabel.textColor = Design.Fonts.RegularText.color
        tempLabel.textAlignment = .center
        tempLabel.text = viewModel.temperature
        contentView.addSubview(tempLabel)
        
        makeConstraints()
    }
}

// MARK: - Private
private extension CurrentTemperatureTableViewCell {
    
    private func makeConstraints() {
        // tempLabel
        tempLabel.snp.remakeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.centerX.equalTo(contentView)
        }
    }
}
