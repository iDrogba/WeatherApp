//
//  DayWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/15.
//

import UIKit

class DayWeatherCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DayWeatherCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "오전 3시"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private let weatherImage: UIImage = {
        let imageView = UIImage()
        return imageView
    }()
    
    private let tempLabel: UILabel = {
       let label = UILabel()
        label.text = "29"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
}
