//
//  WeekWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/09.
//

import UIKit

class WeekWeatherTableViewCell: UICollectionViewCell {
    private var dayLabel: UILabel = {
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
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(white: 0, alpha: 0)
        [dayLabel, weatherImage, rainPercentage, temperatureLabel].forEach {
            contentView.addSubview($0)
        }
        DispatchQueue.main.async {
            self.configureCellConstraints()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        weatherImage.image = nil
        temperatureLabel.text = nil
        rainPercentage.text = ""
    }
    
    private func configureCellConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        rainPercentage.translatesAutoresizingMaskIntoConstraints = false
        
        dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherImage.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
        weatherImage.bottomAnchor.constraint(equalTo: rainPercentage.topAnchor).isActive = true
        
        rainPercentage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        rainPercentage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        rainPercentage.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor).isActive = true
        rainPercentage.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func applyData(_ model: WeatherForecastModel) {
        var dayLabelText: String
        var weatherImageName: String
        dayLabelText = model.forecastTime.prefix(2) + "시"
        
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
            rainPercentage.text = model.POP + "%"
        case "2": // 비 혹은 눈
            weatherImageName = "cloud.sleet"
            rainPercentage.text = model.POP + "%"
        case "3": // 눈
            weatherImageName = "cloud.snow"
            rainPercentage.text = model.POP + "%"
        case "4": //소나기
            weatherImageName = "cloud.drizzle"
            rainPercentage.text = model.POP + "%"
        default:
            break
        }
        dayLabel.text = dayLabelText
        weatherImage.image = UIImage(systemName: weatherImageName)
        temperatureLabel.text = " " + model.TMP + "°"
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
