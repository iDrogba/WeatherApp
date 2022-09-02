//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/12.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(_ regionalDataModel: UpdatedRegionalDataModel) {
        self.textLabel?.text = regionalDataModel.regionName
    }
}
