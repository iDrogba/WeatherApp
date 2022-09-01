//
//  DayWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/15.
//

import UIKit

class DayWeatherCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayStackView)
        contentView.backgroundColor = transparentBackground
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = transparentBackground
        configureCellConstraints()
    }
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.min")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let tempLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
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
        dayStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func applyData(_ model: UpdatedWeatherForecastModel) {
        
        var timeLabelText: String
        var weatherImageName: String = "sun.max"
        var tempLabelText: String
        var dayLabelText: String

//        switch model.SKY {
//        case "1": // 맑음
//            weatherImageName = "sun.max"
//        case "3": // 구름많음
//            weatherImageName = "cloud"
//        case "4": // 흐림
//            weatherImageName = "cloud"
//        default:
//            weatherImageName = "cloud"
//        }
//        
//        switch model.PTY {
//        case "1": // 비
//            weatherImageName = "cloud.rain"
//        case "2": // 비 혹은 눈
//            weatherImageName = "cloud.sleet"
//        case "3": // 눈
//            weatherImageName = "cloud.snow"
//        case "4": //소나기
//            weatherImageName = "cloud.drizzle"
//        default:
//            break
//        }

        let forecastDateMid = model.time.transferStringToDate() ?? Date()
        dayLabelText = forecastDateMid.transferDateToStringDay()
        
        let dateString = model.time.transferStringToTime() ?? Date()
        timeLabelText = dateString.transferTimeToKorean()
        
        if model.time == "0000" {
            timeLabel.text = "\(dayLabelText) \(timeLabelText)"
        } else {
            timeLabel.text = timeLabelText
        }
        
        tempLabelText = model.airTemperature.description
        
        weatherImage.image = UIImage(systemName: weatherImageName)
        tempLabel.text = tempLabelText + "°"
    }
}
