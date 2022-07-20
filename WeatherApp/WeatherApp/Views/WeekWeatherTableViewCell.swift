//
//  WeekWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/09.
//

import UIKit

class WeekWeatherTableViewCell: UITableViewCell {

    private var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private var weatherImage: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .white
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
    
    func applyData(_ model: WeatherForecastModel) {
        var dayLabelText: String
        var weatherImageName: String
        var maxTemp: String
        var minTemp: String
    
        dayLabelText = model.forecastDate
        maxTemp = model.TMP
        minTemp = model.TMP
        
        switch model.SKY {
        case "1": // 맑음
            weatherImageName = "sun.max"
        case "3": // 구름많음
            weatherImageName = "cloud"
        case "4": // 흐림
            weatherImageName = "cloud"
        default:
            weatherImageName = "cloud"
        }
        
        switch model.PTY {
        case "1": // 비
            weatherImageName = "cloud.rain"
        case "2": // 비 혹은 눈
            weatherImageName = "cloud.sleet"
        case "3": // 눈
            weatherImageName = "cloud.snow"
        case "4": //소나기
            weatherImageName = "cloud.drizzle"
        default:
            break
        }

        dayLabel.text = dayLabelText
        weatherImage.image = UIImage(systemName: weatherImageName)
        maxTemperatureLabel.text = maxTemp
        minTemperatureLabel.text = minTemp
    }
    
}
