//
//  DayWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/15.
//

import UIKit

class DayWeatherCollectionViewCell: UICollectionViewCell {
    //static let reuseIdentifier = "DayWeatherCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayStackView)
        
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCellConstraints()
    }
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "오전 3시"
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.min")
        return imageView
    }()
    
    private let tempLabel: UILabel = {
       let label = UILabel()
        label.text = "29"
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var dayStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [timeLabel, weatherImage, tempLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private func configureUI() {
        contentView.layer.cornerRadius = 4
    }
    
    private func configureCellConstraints() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dayStackView.translatesAutoresizingMaskIntoConstraints = false
        dayStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
