//
//  RegionWeatherViewController.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/09.
//

import UIKit

class RegionWeatherViewController: UIViewController {
    
    public var regionalCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [cityLabel, temperatureLabel, degreeLabel, tempStackView, descriptionLabel, surfImageView, waveHeightLabel, weekWeatherTableView, dayWeatherCollectionView].forEach {
            view.addSubview($0)
        }
        
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self
        
        dayWeatherCollectionView.delegate = self
        dayWeatherCollectionView.dataSource = self

        applyData()
        applyBackground()
        applySurfImage()
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    /// RegionWeatherView : 주간 날씨 테이블뷰
    private var weekWeatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WeekWeatherTableViewCell.self, forCellReuseIdentifier: WeekWeatherTableViewCell.reuseIdentifier)
        tableView.backgroundColor = transparentBackground
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    /// RegionWeatherView : 일간 시간별 날씨 컬렉션 뷰
    private let dayWeatherCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(DayWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DayWeatherCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = transparentBackground
        
        return collectionView
    }()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 37, weight: .regular)
        
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "34"
        label.font = .systemFont(ofSize: 96, weight: .semibold)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        return label
    }()
    
    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "℃"
        label.font = .systemFont(ofSize: 40, weight: .light)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
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
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        return label
    }()
    
    private var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "23°"
        label.font = .systemFont(ofSize: 35, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private var surfImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "서핑하기 좋아요"
        label.font = .systemFont(ofSize: 25, weight: .regular)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        return label
    }()
    
    private var waveHeightLabel: UILabel = {
        let label = UILabel()
        label.text = "0.4m"
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        return label
    }()
    
    private func applySurfImage() {
        var surfImageName: String
        guard let model = WeatherForecastModelManager.shared.currentWeatherForecastModels[regionalCode]?.first else { return }
        
        guard let modelWaveValue = Double(model.WAV) else { return }
        if modelWaveValue > 2 { // 높은 파도
            surfImageName = "surf4"
        } else if modelWaveValue > 1 { // 서핑하기 좋음
            surfImageName = "surf3"
        } else if modelWaveValue > 0.5 { // 초심자에게 좋음
            surfImageName = "surf2"
        } else if modelWaveValue == 0 { // 파도 없음
            surfImageName = "surf1"
        } else {
            surfImageName = "surf1"
        }
        
        surfImageView.image = UIImage(named: surfImageName)
    }
    
    private func applyBackground() {
        var backgroundImageName: String
        guard let model = WeatherForecastModelManager.shared.currentWeatherForecastModels[regionalCode]?.first else { return }
        
        switch model.SKY {
        case "1" :
            backgroundImageName = "sunnyFull.png"
        case "3" :
            backgroundImageName = "cloudyFull.png"
        case "4":
            backgroundImageName = "cloudyFull.png"
        default :
            backgroundImageName = "cloudyFull.png"
        }
    
        switch model.PTY {
        case "1" :
            backgroundImageName = "rainyFull.png"
        case "3" :
            backgroundImageName = "snowFull.png"
        default :
            break
        }
        
        let background = UIImage(named: backgroundImageName)
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    func applyData() {
        guard let model = WeatherForecastModelManager.shared.currentWeatherForecastModels[regionalCode]?.first else { return }
        guard let pastTMXModel = WeatherForecastModelManager.shared.pastWeatherForecastModels[regionalCode]?.filter({ $0.forecastTime == "0600" }).first else { return }
        guard let pastTMMModel = WeatherForecastModelManager.shared.pastWeatherForecastModels[regionalCode]?.filter({ $0.forecastTime == "1500" }).first else { return }
        
        var descriptionLabelText: String
        
        guard let modelWaveValue = Double(model.WAV) else { return }
        if modelWaveValue > 2 {
            descriptionLabelText = "파도가 높습니다."
        } else if modelWaveValue > 1 {
            descriptionLabelText = "서핑하기 좋습니다."
        } else if modelWaveValue > 0.5 {
            descriptionLabelText = "초심자가 놀기 좋습니다."
        } else if modelWaveValue == 0 {
            descriptionLabelText = "파도가 없는 지역입니다."
            waveHeightLabel.text = ""
        } else {
            descriptionLabelText = "파도가 약합니다."
        }
        
        cityLabel.text = model.regionName
        temperatureLabel.text = model.TMP
        minTemperatureLabel.text = pastTMMModel.TMP + "°"
        maxTemperatureLabel.text = pastTMXModel.TMP + "°"
        descriptionLabel.text = descriptionLabelText
        waveHeightLabel.text = model.WAV + "m"
    }
    
    private func configureConstraints() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        degreeLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        surfImageView.translatesAutoresizingMaskIntoConstraints = false
        waveHeightLabel.translatesAutoresizingMaskIntoConstraints = false
        dayWeatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        weekWeatherTableView.translatesAutoresizingMaskIntoConstraints = false

        
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1).isActive = true
        
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10).isActive = true
        
        degreeLabel.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor).isActive = true
        degreeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20).isActive = true
        
        tempStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempStackView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5).isActive = true
        
        surfImageView.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 10).isActive = true
        surfImageView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.2).isActive = true
        surfImageView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.6).isActive = true
        surfImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        surfImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        surfImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: surfImageView.bottomAnchor, constant: 10).isActive = true
        
        waveHeightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waveHeightLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        
        dayWeatherCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dayWeatherCollectionView.topAnchor.constraint(equalTo: waveHeightLabel.bottomAnchor, constant: 10).isActive = true
        dayWeatherCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dayWeatherCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dayWeatherCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        dayWeatherCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 9).isActive = true
        
        weekWeatherTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weekWeatherTableView.topAnchor.constraint(equalTo: dayWeatherCollectionView.bottomAnchor, constant: 10).isActive = true
        weekWeatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        weekWeatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weekWeatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension RegionWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: WeekWeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeekWeatherTableViewCell else { return UITableViewCell() }
        
        guard let todayModel = WeatherForecastModelManager.shared.pastWeatherForecastModels[regionalCode]?.first else { return UITableViewCell() }
        
        guard let futureModel =
                WeatherForecastModelManager.shared.currentWeatherForecastModels[regionalCode]?.filter({$0.forecastTime == "0000"}) else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        
        if indexPath.row == 0 {
            cell.applyData(todayModel)
        } else {
            cell.applyData(futureModel[indexPath.row - 1])
        }
        
        print("todayModel: \(todayModel)")
        print("futuremodel: \(futureModel)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension RegionWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as? DayWeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .clear
        
        guard let todayModel =
                WeatherForecastModelManager.shared.currentWeatherForecastModels[regionalCode] else { return UICollectionViewCell() }
        
        cell.applyData(todayModel[indexPath.row])
        
        print("today model: \(todayModel)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: view.frame.width / 6, height: collectionView.frame.height)
        return itemSize
    }
}
