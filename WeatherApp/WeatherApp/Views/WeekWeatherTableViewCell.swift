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
        label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        label.textColor = .white
        return label
    }()
    
    private var weatherImage: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .white
        return imageView
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor(white: 0, alpha: 0)
        [dayLabel, weatherImage, temperatureLabel].forEach {
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
        temperatureLabel.text = nil
    }
    
    private func configureCellConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * 0.05).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: contentView.bounds.width * -0.05).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func applyData(_ model: WeatherForecastModel) {
        var dayLabelText: String
        var weatherImageName: String

//        var dayLabelTextDate: Date
//        dayLabelTextDate = currentTMNModel.forecastDate.transferStringToDate() ?? Date()
//        dayLabelText = dayLabelTextDate.transferDateToString()
        
        
        dayLabelText = model.forecastDate + model.forecastTime
        
        switch model.SKY {
        case "1": // ??????
            weatherImageName = "sun.max"
        case "3": // ????????????
            weatherImageName = "cloud"
        case "4": // ??????
            weatherImageName = "cloud"
        default:
            weatherImageName = "cloud"
        }
        
        switch model.PTY {
        case "1": // ???
            weatherImageName = "cloud.rain"
        case "2": // ??? ?????? ???
            weatherImageName = "cloud.sleet"
        case "3": // ???
            weatherImageName = "cloud.snow"
        case "4": //?????????
            weatherImageName = "cloud.drizzle"
        default:
            break
        }

        dayLabel.text = dayLabelText
        weatherImage.image = UIImage(systemName: weatherImageName)
        temperatureLabel.text = model.TMP
    }
}
