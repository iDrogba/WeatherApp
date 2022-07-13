//
//  WeekWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/09.
//

import UIKit

class WeekWeatherTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "WeekWeatherTableViewCell"

    private var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private var weatherImage: UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    private var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    lazy var tempStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [minTemperatureLabel, maxTemperatureLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        [dayLabel, weatherImage, tempStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(day: String, imageName: String, min: String, max: String) {
        dayLabel.text = day
        weatherImage.image = UIImage(systemName: imageName)
        minTemperatureLabel.text = min
        maxTemperatureLabel.text = max
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        weatherImage.image = nil
        minTemperatureLabel.text = nil
        maxTemperatureLabel.text = nil
    }
    
    private func configureCellConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        
        dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        tempStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        tempStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
