//
//  mainCollectionViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    private let waveLabel: UILabel = {
        let waveLabel = UILabel()
        waveLabel.translatesAutoresizingMaskIntoConstraints = false
        waveLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        waveLabel.textColor = .white
        waveLabel.layer.opacity = 0.8
        
        return waveLabel
    }()
    
    private let surfConditionLabel: UILabel = {
        let surfConditionLabel = UILabel()
        surfConditionLabel.translatesAutoresizingMaskIntoConstraints = false
        surfConditionLabel.text = "서핑하기 좋아요."
        surfConditionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        surfConditionLabel.textColor = .white
        surfConditionLabel.layer.opacity = 0.8

        return surfConditionLabel
    }()
    
    private let weatherLabel: UILabel = {
        let weatherLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.text = "흐림"
        weatherLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        weatherLabel.textColor = .white
        
        return weatherLabel
    }()
    
    private let minTemperatureLabel: UILabel = {
        let minTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.text = "최저:17°"
        minTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        minTemperatureLabel.textColor = .white
        
        return minTemperatureLabel
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let maxTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.text = "최고:28°"
        maxTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        maxTemperatureLabel.textColor = .white
        
        return maxTemperatureLabel
    }()
    
    private let currentTemperatuerLabel: UILabel = {
        let temperatuerLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        temperatuerLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatuerLabel.text = "25°"
        temperatuerLabel.font = .systemFont(ofSize: 48, weight: .regular)
        temperatuerLabel.textColor = .white
//        temperatuerLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
//        temperatuerLabel.layer.shadowOpacity = 0.5
//        temperatuerLabel.layer.shadowRadius = 2
//        temperatuerLabel.layer.shadowColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        
        return temperatuerLabel
    }()
    
    private let regionLabel: UILabel = {
        let regionLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        regionLabel.text = "포항시"
        regionLabel.font = .systemFont(ofSize: 24, weight: .bold)
        regionLabel.textColor = .white
//        regionLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
//        regionLabel.layer.shadowOpacity = 0.5
//        regionLabel.layer.shadowRadius = 2
//        regionLabel.layer.shadowColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        
        return regionLabel
    }()
    
    private let foregroundImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(backgroundImageView)
        self.contentView.addSubview(foregroundImageView)
        self.contentView.addSubview(regionLabel)
        self.contentView.addSubview(currentTemperatuerLabel)
        self.contentView.addSubview(minTemperatureLabel)
        self.contentView.addSubview(maxTemperatureLabel)
        self.contentView.addSubview(weatherLabel)
        self.contentView.addSubview(surfConditionLabel)
        self.contentView.addSubview(waveLabel)
        self.backgroundColor = .gray
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.setConstraints()
        }
    }
    
    func setUI(_ model: WeatherForecastModel) {
        var foregroundImageName: String
        var backgroundImageName: String
        switch model.SKY {
        case "1" :
            backgroundImageName = "sunny.png"
        default :
            backgroundImageName = "cloudy.png"
        }
    
        switch model.PTY {
        case "1" :
            backgroundImageName = "rainy.png"
        case "3" :
            backgroundImageName = "snow.png"
        default :
            break
        }
        guard let modelWaveValue = Double(model.WAV) else {
            return
        }
        
        if modelWaveValue > 2 {
            foregroundImageName = "surf4.png"
        } else if modelWaveValue > 1 {
            foregroundImageName = "surf3.png"
        } else if modelWaveValue > 0.5 {
            foregroundImageName = "surf2.png"
        } else if modelWaveValue == 0 {
            foregroundImageName = ""
        } else {
            foregroundImageName = "surf1.png"
        }
        foregroundImageView.image = UIImage(named: foregroundImageName)
        backgroundImageView.image = UIImage(named: backgroundImageName)
        regionLabel.text = model.regionName
        currentTemperatuerLabel.text = model.TMP + "°"
        if model.WAV == "0" {
            surfConditionLabel.text = "파도가 없는 지역입니다."
        } else {
            waveLabel.text = "파고: " + model.WAV + "m"
        }
    }
    
    func setConstraints() {
        let backgroundImageViewConstraints = [
            backgroundImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ]
        let foregroundImageViewConstraints = [
            foregroundImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            foregroundImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            foregroundImageView.widthAnchor.constraint(equalTo: foregroundImageView.heightAnchor),
            foregroundImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ]
        let regionLabelConstraints = [
            regionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            regionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15)
        ]
        let temperatureLabelConstraints = [
            currentTemperatuerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            currentTemperatuerLabel.topAnchor.constraint(equalTo: regionLabel.topAnchor, constant: 0),
        ]
        let maxTemperatureLabelConstraints = [
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor, constant: -5),
            maxTemperatureLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ]
        let minTemperatureLabelConstraints = [
            minTemperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            minTemperatureLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ]
        let weatherLabelConstraints = [
            weatherLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.trailingAnchor, constant: 0),
            weatherLabel.bottomAnchor.constraint(equalTo: maxTemperatureLabel.topAnchor, constant: 0)
        ]
        let surfConditionLabelConstraints = [
            surfConditionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            surfConditionLabel.centerYAnchor.constraint(equalTo: maxTemperatureLabel.centerYAnchor, constant: 0)
        ]
        let waveLabelConstraints = [
            waveLabel.leadingAnchor.constraint(equalTo: surfConditionLabel.leadingAnchor),
            waveLabel.bottomAnchor.constraint(equalTo: surfConditionLabel.topAnchor)
        ]
        NSLayoutConstraint.activate(backgroundImageViewConstraints)
        NSLayoutConstraint.activate(foregroundImageViewConstraints)
        NSLayoutConstraint.activate(regionLabelConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
        NSLayoutConstraint.activate(maxTemperatureLabelConstraints)
        NSLayoutConstraint.activate(minTemperatureLabelConstraints)
        NSLayoutConstraint.activate(weatherLabelConstraints)
        NSLayoutConstraint.activate(surfConditionLabelConstraints)
        NSLayoutConstraint.activate(waveLabelConstraints)
    }
}
