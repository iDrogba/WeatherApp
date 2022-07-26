//
//  mainCollectionViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import UIKit

class MainCollectionViewCell: UITableViewCell {
    private lazy var subRegionLabel: UILabel = {
        let subRegionLabel = UILabel()
        subRegionLabel.translatesAutoresizingMaskIntoConstraints = false
        subRegionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        subRegionLabel.textColor = .white
        subRegionLabel.layer.opacity = 0.8

        return subRegionLabel
    }()
    
    private lazy var waveLabel: UILabel = {
        let waveLabel = UILabel()
        waveLabel.translatesAutoresizingMaskIntoConstraints = false
        waveLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        waveLabel.textColor = .white
        waveLabel.layer.opacity = 0.8
        
        return waveLabel
    }()
    
    private lazy var surfConditionLabel: UILabel = {
        let surfConditionLabel = UILabel()
        surfConditionLabel.translatesAutoresizingMaskIntoConstraints = false
        surfConditionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        surfConditionLabel.textColor = .white
        surfConditionLabel.layer.opacity = 0.8
        
        return surfConditionLabel
    }()
    
    private lazy var skyConditionLabel: UILabel = {
        let weatherLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        weatherLabel.textColor = .white
        weatherLabel.text = "_"
        
        return weatherLabel
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let minTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        minTemperatureLabel.textColor = .white
        minTemperatureLabel.text = "최저: _"

        return minTemperatureLabel
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let maxTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        maxTemperatureLabel.textColor = .white
        maxTemperatureLabel.text = "최고: _"
        
        return maxTemperatureLabel
    }()
    
    private lazy var currentTemperatuerLabel: UILabel = {
        let temperatuerLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        temperatuerLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatuerLabel.text = "_"
        temperatuerLabel.font = .systemFont(ofSize: 40, weight: .regular)
        temperatuerLabel.textColor = .white

        return temperatuerLabel
    }()
    
    private lazy var regionLabel: UILabel = {
        let regionLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        regionLabel.font = .systemFont(ofSize: 24, weight: .bold)
        regionLabel.textColor = .white
        regionLabel.text = "_"
        
        return regionLabel
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: "sunny")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(backgroundImageView)
        self.contentView.addSubview(regionLabel)
        self.contentView.addSubview(subRegionLabel)
        self.contentView.addSubview(currentTemperatuerLabel)
        self.contentView.addSubview(minTemperatureLabel)
        self.contentView.addSubview(maxTemperatureLabel)
        self.contentView.addSubview(skyConditionLabel)
        self.contentView.addSubview(surfConditionLabel)
        self.contentView.addSubview(waveLabel)
        self.backgroundColor = .gray
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
        self.selectedBackgroundView = UIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        DispatchQueue.main.async {
            self.setConstraints()
            self.backgroundColor = .systemBackground
            self.contentView.backgroundColor = .systemBackground
        }
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    func setUI(_ model: WeatherForecastModel, _ pastTMNModel: WeatherForecastModel, _ pastTMXModel: WeatherForecastModel) {
        var surfConditionText: String
        var backgroundImageName: String
        var skyCondition: String
        
        switch model.SKY {
        case "1" :
            backgroundImageName = "sunny.png"
            skyCondition = "맑음"
        case "3" :
            backgroundImageName = "cloudy.png"
            skyCondition = "구름 많음"
        case "4":
            backgroundImageName = "cloudy.png"
            skyCondition = "흐림"
        default :
            backgroundImageName = "cloudy.png"
            skyCondition = "구름 많음"
        }
    
        switch model.PTY {
        case "1" :
            backgroundImageName = "rainy.png"
        case "3" :
            backgroundImageName = "snow.png"
        default :
            break
        }
       
        waveLabel.text = "파고: " + model.WAV + "m"
        guard let modelWaveValue = Double(model.WAV) else { return }
        if modelWaveValue >= 2 {
            surfConditionText = "파도가 높습니다"
        } else if modelWaveValue >= 1 {
            surfConditionText = "서핑을 즐기기 좋습니다"
        } else if modelWaveValue >= 0.5 {
            surfConditionText = "초심자가 즐기기 좋습니다"
        } else if modelWaveValue == 0 {
            surfConditionText = "파도가 없거나 약한 지역입니다"
            waveLabel.text = ""
        } else {
            surfConditionText = "파도가 약합니다"
        }
        
        let TMX = Int(round(Double(pastTMXModel.TMX) ?? 0))
        let TMN = Int(round(Double(pastTMNModel.TMN) ?? 0))
        
        minTemperatureLabel.text = "최저:" + String(describing: TMN) + "°"
        maxTemperatureLabel.text = "최고:" + String(describing: TMX) + "°"
        currentTemperatuerLabel.text = model.TMP + "°"
        surfConditionLabel.text = surfConditionText
        skyConditionLabel.text = skyCondition
        backgroundImageView.image = UIImage(named: backgroundImageName)
        regionLabel.text = model.regionName
        subRegionLabel.text = model.subRegionName
//        minTemperatureLabel.text = "최저:" + pastTMNModel.TMN + "°"
//        maxTemperatureLabel.text = "최고:" + pastTMXModel.TMX + "°"
    }
    
    func setConstraints() {
        let backgroundImageViewConstraints = [
            backgroundImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ]
        let regionLabelConstraints = [
            regionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            regionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15)
        ]
        let subRegionLabelConstraints = [
            subRegionLabel.leadingAnchor.constraint(equalTo: self.regionLabel.trailingAnchor, constant: 5),
            subRegionLabel.centerYAnchor.constraint(equalTo: self.regionLabel.centerYAnchor)
        ]
        let temperatureLabelConstraints = [
            currentTemperatuerLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            currentTemperatuerLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
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
            skyConditionLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.trailingAnchor, constant: 0),
            skyConditionLabel.bottomAnchor.constraint(equalTo: maxTemperatureLabel.topAnchor, constant: 0)
        ]
        let surfConditionLabelConstraints = [
            surfConditionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            surfConditionLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -10)
        ]
        let waveLabelConstraints = [
            waveLabel.leadingAnchor.constraint(equalTo: surfConditionLabel.leadingAnchor),
            waveLabel.bottomAnchor.constraint(equalTo: surfConditionLabel.topAnchor)
        ]
        NSLayoutConstraint.activate(backgroundImageViewConstraints)
        NSLayoutConstraint.activate(regionLabelConstraints)
        NSLayoutConstraint.activate(subRegionLabelConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
        NSLayoutConstraint.activate(maxTemperatureLabelConstraints)
        NSLayoutConstraint.activate(minTemperatureLabelConstraints)
        NSLayoutConstraint.activate(weatherLabelConstraints)
        NSLayoutConstraint.activate(surfConditionLabelConstraints)
        NSLayoutConstraint.activate(waveLabelConstraints)
    }
}

class PlaceHolderCollectionViewCell: UITableViewCell {
    private lazy var subRegionLabel: UILabel = {
        let subRegionLabel = UILabel()
        subRegionLabel.translatesAutoresizingMaskIntoConstraints = false
        subRegionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        subRegionLabel.textColor = .white
        subRegionLabel.layer.opacity = 0.8

        return subRegionLabel
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let minTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        minTemperatureLabel.textColor = .white
        minTemperatureLabel.text = "최저: _°"

        return minTemperatureLabel
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let maxTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        maxTemperatureLabel.textColor = .white
        maxTemperatureLabel.text = "최고: _°"
        
        return maxTemperatureLabel
    }()
    
    private lazy var currentTemperatuerLabel: UILabel = {
        let temperatuerLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        temperatuerLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatuerLabel.text = "_°"
        temperatuerLabel.font = .systemFont(ofSize: 48, weight: .regular)
        temperatuerLabel.textColor = .white

        return temperatuerLabel
    }()
    
    private lazy var regionLabel: UILabel = {
        let regionLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        regionLabel.font = .systemFont(ofSize: 24, weight: .bold)
        regionLabel.textColor = .white
        regionLabel.text = "_"
        
        return regionLabel
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: "sunny")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(backgroundImageView)
        self.contentView.addSubview(regionLabel)
        self.contentView.addSubview(subRegionLabel)
        self.contentView.addSubview(currentTemperatuerLabel)
        self.contentView.addSubview(minTemperatureLabel)
        self.contentView.addSubview(maxTemperatureLabel)
        self.backgroundColor = .gray
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
        self.selectedBackgroundView = UIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        
        DispatchQueue.main.async { [self] in
            self.setConstraints()
            self.backgroundColor = .systemBackground
            self.contentView.backgroundColor = .systemBackground
        }
    }
    
    func setUI(_ regionalCode: String) {
        let regionalModel = RegionalDataManager.shared.retrieveRegionalDataModel(regionalCode)
        regionLabel.text = regionalModel?.regionName
        subRegionLabel.text = regionalModel?.third
    }
    
    func setConstraints() {
        let backgroundImageViewConstraints = [
            backgroundImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ]
        let regionLabelConstraints = [
            regionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            regionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15)
        ]
        let subRegionLabelConstraints = [
            subRegionLabel.leadingAnchor.constraint(equalTo: self.regionLabel.trailingAnchor, constant: 5),
            subRegionLabel.centerYAnchor.constraint(equalTo: self.regionLabel.centerYAnchor)
        ]
        let temperatureLabelConstraints = [
            currentTemperatuerLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            currentTemperatuerLabel.topAnchor.constraint(equalTo: regionLabel.topAnchor, constant: 0),
        ]
        let maxTemperatureLabelConstraints = [
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor, constant: -5),
            maxTemperatureLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -10)
        ]
        let minTemperatureLabelConstraints = [
            minTemperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            minTemperatureLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(backgroundImageViewConstraints)
        NSLayoutConstraint.activate(regionLabelConstraints)
        NSLayoutConstraint.activate(subRegionLabelConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
        NSLayoutConstraint.activate(maxTemperatureLabelConstraints)
        NSLayoutConstraint.activate(minTemperatureLabelConstraints)
    }
}
