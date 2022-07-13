//
//  mainCollectionViewCell.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/08.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MainCollectionViewCell"
    
    private let surfConditionLabel: UILabel = {
        let surfConditionLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        surfConditionLabel.translatesAutoresizingMaskIntoConstraints = false
        surfConditionLabel.text = "서핑하기 좋아요."
        surfConditionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        surfConditionLabel.textColor = .white
        
        return surfConditionLabel
    }()
    
    private let weatherLabel: UILabel = {
        let weatherLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.text = "흐림"
        weatherLabel.font = .systemFont(ofSize: 12, weight: .regular)
        weatherLabel.textColor = .white
        
        return weatherLabel
    }()
    
    private let minTemperatureLabel: UILabel = {
        let minTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.text = "최저:17°"
        minTemperatureLabel.font = .systemFont(ofSize: 12, weight: .regular)
        minTemperatureLabel.textColor = .white
        
        return minTemperatureLabel
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let maxTemperatureLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.text = "최고:28°"
        maxTemperatureLabel.font = .systemFont(ofSize: 12, weight: .regular)
        maxTemperatureLabel.textColor = .white
        
        return maxTemperatureLabel
    }()
    
    private let currentTemperatuerLabel: UILabel = {
        let temperatuerLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        temperatuerLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatuerLabel.text = "25°"
        temperatuerLabel.font = .systemFont(ofSize: 48, weight: .medium)
        temperatuerLabel.textColor = .white
        
        return temperatuerLabel
    }()
    
    private let regionLabel: UILabel = {
        let regionLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        regionLabel.text = "포항시"
        regionLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        regionLabel.textColor = .white
        
        return regionLabel
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(regionLabel)
        self.addSubview(currentTemperatuerLabel)
        self.addSubview(minTemperatureLabel)
        self.addSubview(maxTemperatureLabel)
        self.addSubview(weatherLabel)
        self.addSubview(surfConditionLabel)
        self.backgroundColor = .gray
        self.clipsToBounds = true
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
    
    func setUI() {
        self.layer.cornerRadius = 4
        imageView.image = UIImage(named: "surf2.png")
    }
    
    func setConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        let regionLabelConstraints = [
            regionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            regionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        ]
        let temperatureLabelConstraints = [
            currentTemperatuerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            currentTemperatuerLabel.topAnchor.constraint(equalTo: regionLabel.topAnchor, constant: 0),
        ]
        let maxTemperatureLabelConstraints = [
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor, constant: -5),
            maxTemperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ]
        let minTemperatureLabelConstraints = [
            minTemperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            minTemperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ]
        let weatherLabelConstraints = [
            weatherLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.trailingAnchor, constant: 0),
            weatherLabel.bottomAnchor.constraint(equalTo: maxTemperatureLabel.topAnchor, constant: 0)
        ]
        let surfConditionLabelConstraints = [
            surfConditionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            surfConditionLabel.centerYAnchor.constraint(equalTo: maxTemperatureLabel.centerYAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(regionLabelConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
        NSLayoutConstraint.activate(maxTemperatureLabelConstraints)
        NSLayoutConstraint.activate(minTemperatureLabelConstraints)
        NSLayoutConstraint.activate(weatherLabelConstraints)
        NSLayoutConstraint.activate(surfConditionLabelConstraints)
    }
}
