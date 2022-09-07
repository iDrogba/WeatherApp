//
//  mainCollectionViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import UIKit
//MARK: MainCollectionViewCell
class MainCollectionViewCell: UITableViewCell {
    var surfCondition: SurfConditionOutput? = nil
    var highestWaveHeight: Double = 0
    var lowestWaveHeight: Double = 0
    
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
    
    private lazy var maxTemperatureLabel: UILabel = {
        let maxTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        maxTemperatureLabel.textColor = .white
        maxTemperatureLabel.text = "최고: _"

        return maxTemperatureLabel
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let minTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        minTemperatureLabel.textColor = .white
        minTemperatureLabel.text = "최저: _"
        
        return minTemperatureLabel
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
        self.contentView.addSubview(maxTemperatureLabel)
        self.contentView.addSubview(minTemperatureLabel)
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
    
    func setUI(_ models: [UpdatedWeatherForecastModel]) {
        var surfConditionLabelText = "파도가 없는 지역입니다"
        var backgroundImageName = "sunny.png"
        var skyCondition = "맑음"
        
        guard let currentModel = models.first(where: { (Date.dateA - $0.time) < 3600 }) else { return }
        highestWaveHeight = currentModel.waveHeight
        lowestWaveHeight = currentModel.waveHeight
        
        models.forEach{
            if $0.waveHeight > highestWaveHeight {
                highestWaveHeight = $0.waveHeight
            }
            if $0.waveHeight < lowestWaveHeight {
                lowestWaveHeight = $0.waveHeight
            }
        }
        
        if currentModel.cloudCover <= 30 {
            backgroundImageName = "sunny.png"
            skyCondition = "맑음"
        } else if currentModel.cloudCover <= 50 {
            backgroundImageName = "sunny.png"
            skyCondition = "약간 흐림"
        } else if currentModel.cloudCover <= 80 {
            backgroundImageName = "cloudy.png"
            skyCondition = "구름 많음"
        } else if currentModel.cloudCover <= 100 {
            backgroundImageName = "cloudy.png"
            skyCondition = "흐림"
        }
        
        if currentModel.precipitation > 0.1 {
            backgroundImageName = "rainy.png"
            skyCondition = "비"
        }
        if currentModel.snowDepth > 0.1 {
            backgroundImageName = "snow.png"
            skyCondition = "눈"
        }
                
        waveLabel.text = "파고: " + currentModel.waveHeight.description + "m"

        // wind 바꾸기
        guard let surfCondition = ML.shared.fetchPrediction(wave: currentModel.waveHeight, wind: currentModel.windSpeed) else { return }
        self.surfCondition = surfCondition
        guard let surfConditionDouble = Double(surfCondition.X1) else { return }

        switch surfConditionDouble {
        case 0:
            if currentModel.waveHeight == 0 {
                surfConditionLabelText = "파도가 없는 지역입니다"
            } else {
                surfConditionLabelText = "파도가 약합니다"
            }
        case 1:
            surfConditionLabelText = "입문자가 즐기기 좋습니다"
        case 2:
            surfConditionLabelText = "초급자가 즐기기 좋습니다"
        case 3:
            surfConditionLabelText = "중급자가 즐기기 좋습니다"
        case 4:
            surfConditionLabelText = "상급자가 즐기기 좋습니다"
        case 5:
            surfConditionLabelText = "서핑을 즐기기 위험합니다"
        default:
            surfConditionLabelText = "오류"
        }
        
        minTemperatureLabel.text = "최고:" + highestWaveHeight.description + "m"
        maxTemperatureLabel.text = "최저:" + lowestWaveHeight.description + "m"
        currentTemperatuerLabel.text = currentModel.airTemperature.description + "°"
        surfConditionLabel.text = surfConditionLabelText
        skyConditionLabel.text = skyCondition
        backgroundImageView.image = UIImage(named: backgroundImageName)
        regionLabel.text = currentModel.regionName
        subRegionLabel.text = currentModel.subRegionName
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
            minTemperatureLabel.trailingAnchor.constraint(equalTo: maxTemperatureLabel.leadingAnchor, constant: -5),
            minTemperatureLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ]
        let minTemperatureLabelConstraints = [
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            maxTemperatureLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ]
        let weatherLabelConstraints = [
            skyConditionLabel.trailingAnchor.constraint(equalTo: maxTemperatureLabel.trailingAnchor, constant: 0),
            skyConditionLabel.bottomAnchor.constraint(equalTo: minTemperatureLabel.topAnchor, constant: 0)
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


//MARK: PlaceHolderCollectionViewCell
class PlaceHolderCollectionViewCell: UITableViewCell {    
    private lazy var subRegionLabel: UILabel = {
        let subRegionLabel = UILabel()
        subRegionLabel.translatesAutoresizingMaskIntoConstraints = false
        subRegionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        subRegionLabel.textColor = .white
        subRegionLabel.layer.opacity = 0.8

        return subRegionLabel
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let maxTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        maxTemperatureLabel.textColor = .white
        maxTemperatureLabel.text = "최저: _°"

        return maxTemperatureLabel
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let minTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        minTemperatureLabel.textColor = .white
        minTemperatureLabel.text = "최고: _°"
        
        return minTemperatureLabel
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
        self.contentView.addSubview(maxTemperatureLabel)
        self.contentView.addSubview(minTemperatureLabel)
        self.backgroundColor = .gray
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
        self.selectedBackgroundView = UIView()
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) {timer in
                UILabel.animate(withDuration: 1, delay: 0.0, options: [.curveEaseInOut], animations: {
                    if self.maxTemperatureLabel.alpha == 1 {
                        self.maxTemperatureLabel.alpha = 0.2
                        self.minTemperatureLabel.alpha = 0.2
                        self.currentTemperatuerLabel.alpha = 0.2
                        
                    } else {
                        self.maxTemperatureLabel.alpha = 1
                        self.minTemperatureLabel.alpha = 1
                        self.currentTemperatuerLabel.alpha = 1
                    }
                }, completion: nil)
            }
        }
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
        let regionalModel = UpdatedRegionalDataModelManager.shared.retrieveRegionalDataModel(regionalCode)
        regionLabel.text = regionalModel?.first
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
            minTemperatureLabel.trailingAnchor.constraint(equalTo: maxTemperatureLabel.leadingAnchor, constant: -5),
            minTemperatureLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -10)
        ]
        let minTemperatureLabelConstraints = [
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            maxTemperatureLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(backgroundImageViewConstraints)
        NSLayoutConstraint.activate(regionLabelConstraints)
        NSLayoutConstraint.activate(subRegionLabelConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
        NSLayoutConstraint.activate(maxTemperatureLabelConstraints)
        NSLayoutConstraint.activate(minTemperatureLabelConstraints)
    }
}
