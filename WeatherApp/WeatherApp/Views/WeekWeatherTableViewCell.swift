//
//  WeekWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Lena, Drogba on 2022/07/09.
//

import UIKit

class WeekWeatherTableViewCell: UICollectionViewCell {
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()
    
    private var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private var rainPercentage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [self] in
            self.contentView.backgroundColor = UIColor(white: 0, alpha: 0)
            [timeLabel, weatherImage, rainPercentage, temperatureLabel].forEach {
                self.contentView.addSubview($0)
            }
            self.configureCellConstraints()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        weatherImage.image = nil
        temperatureLabel.text = nil
        rainPercentage.text = ""
    }
    
    private func configureCellConstraints() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        rainPercentage.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        weatherImage.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        weatherImage.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor).isActive = true
        weatherImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        rainPercentage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        rainPercentage.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor).isActive = true
        rainPercentage.heightAnchor.constraint(equalTo: weatherImage.heightAnchor, multiplier: 0.25).isActive = true
        
        temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func applyData(_ model: UpdatedWeatherForecastModel) {
        var timeLabelText: String
        timeLabelText = model.time.transferTimeToStringTime()
        var weatherImageName: String = "sun.max"
        if model.cloudCover <= 30 {
            // 맑음
            weatherImageName = "sun.max"
        } else if model.cloudCover <= 50 {
            // 약간 흐림
            weatherImageName = "cloud"
        } else if model.cloudCover <= 80 {
            // 구름 많음
            weatherImageName = "cloud"
        } else if model.cloudCover <= 100 {
            // 흐림
            weatherImageName = "cloud"
        }
        
        if model.precipitation > 0.1 {
            // 비
            weatherImageName = "cloud.rain"
            rainPercentage.text = model.precipitation.description + "mm/h"
        }
        if model.snowDepth > 0.1 {
            // 눈
            weatherImageName = "cloud.snow"
            rainPercentage.text = model.snowDepth.description + "m"
        }

        timeLabel.text = timeLabelText
        weatherImage.image = UIImage(systemName: weatherImageName)
        temperatureLabel.text = " " + model.airTemperature.description + "°"
    }
}

class WeekWeatherCollectionViewHeader: UICollectionReusableView {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(dateLabel)
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private func setConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
