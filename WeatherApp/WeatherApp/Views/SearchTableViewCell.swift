//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/12.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let reuseIdentifier = "searchTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(_ regionalDataModel: RegionalDataModel) {
        self.textLabel?.text = regionalDataModel.first + " " + regionalDataModel.second + " " + regionalDataModel.third
    }
}
