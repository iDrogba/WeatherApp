//
//  RegionWeatherViewController.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/09.
//

import UIKit

class RegionWeatherViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(degreeLabel)
        view.addSubview(tempStackView)
        view.addSubview(descriptionLabel)
        view.addSubview(waveHeightLabel)
        
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "포항시"
        label.font = .systemFont(ofSize: 37, weight: .regular)
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "34"
        label.font = .systemFont(ofSize: 96, weight: .semibold)
        return label
    }()
    
    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "℃"
        label.font = .systemFont(ofSize: 40, weight: .light)
        return label
    }()
    
    lazy var tempStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [maxTemperatureLabel, minTemperatureLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "34°"
        label.font = .systemFont(ofSize: 35, weight: .regular)
        return label
    }()
    
    private var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "23°"
        label.font = .systemFont(ofSize: 35, weight: .regular)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "서핑하기 좋아요"
        label.font = .systemFont(ofSize: 25, weight: .regular)
        return label
    }()
    
    private var waveHeightLabel: UILabel = {
        let label = UILabel()
        label.text = "0.4m"
        label.font = .systemFont(ofSize: 20, weight: .light)
        return label
    }()
    
    private func configureConstraints() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        degreeLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        waveHeightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1).isActive = true
        
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10).isActive = true
        
        degreeLabel.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor).isActive = true
        degreeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20).isActive = true
        
        tempStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempStackView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: view.bounds.height * 0.15).isActive = true
        
        waveHeightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waveHeightLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
    }
    
//    func createLabel(labelText: String, textSize: CGFloat, textWeight: UIFont.Weight) -> UILabel {
//        let label = UILabel()
//        label.text = labelText
//        label.font = .systemFont(ofSize: textSize, weight: textWeight)
//        return label
//    }

}
