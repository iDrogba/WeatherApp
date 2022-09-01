//
//  RegionWeatherViewController.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/09.
//

import UIKit
import Charts

class RegionWeatherViewController: UIViewController {
    public var regionalCode: String = ""
    private var dateArray: [String] = []
    private var weatherForecastModels: [String:[UpdatedWeatherForecastModel]] = [:]
    var surfConditionOutput: SurfConditionOutput!
    var waveLineChartEntry = [ChartDataEntry]() // graph 에 보여줄 wave data array
    var windLineChartEntry = [ChartDataEntry]() // graph 에 보여줄 wind data array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let forecastDateArray = UpdatedWeatherForecastModelManager.shared.weatherForecastModels[regionalCode]
//        forecastDateArray?.forEach{
//            if weatherForecastModels[$0.forecastDate] == nil {
//                weatherForecastModels.updateValue([$0], forKey: $0.forecastDate)
//            } else {
//                weatherForecastModels[$0.forecastDate]?.append($0)
//            }
//            
//        }
        dateArray = weatherForecastModels.keys.sorted(by: <)
        
        [cityLabel, temperatureLabel, degreeLabel, tempStackView, descriptionLabel, mlPercentageLabel, surfImageView, waveWindLabel, weekWeatherTableView, chart].forEach {
            view.addSubview($0)
        }
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self
        chart.delegate = self

        DispatchQueue.main.async {
            self.configureConstraints()
            self.applyData()
            self.applyBackground()
            self.applySurfConditionImageLabel()
            self.setChart()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    /// RegionWeatherView : 주간 날씨 테이블뷰
    private var weekWeatherTableView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let tableView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        tableView.register(WeekWeatherTableViewCell.self, forCellWithReuseIdentifier: WeekWeatherTableViewCell.reuseIdentifier)
        tableView.register(WeekWeatherCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeekWeatherCollectionViewHeader.reuseIdentifier)
        tableView.backgroundColor = transparentBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 37, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .semibold)
        label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "℃"
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var tempStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [maxTemperatureLabel, minTemperatureLabel])
        stackView.axis = .horizontal
        stackView.spacing = view.bounds.width * 0.03
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var surfImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var waveWindLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.frame = CGRect()
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.frame = CGRect()
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var mlPercentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var chart: LineChartView = {
        guard let regionWeatherForecastModelArray = UpdatedWeatherForecastModelManager.shared.weatherForecastModels[regionalCode] else { return LineChartView() }
        let chart  = LineChartView()
        let xScale = Double(regionWeatherForecastModelArray.count / 7)
        let yScale = 2.0
        chart.zoom(scaleX: xScale, scaleY: yScale, x: 0, y: 0)
        chart.rightAxis.enabled = false
        chart.rightAxis.labelTextColor = .white
        chart.rightAxis.gridColor = .white

        chart.leftAxis.axisMaximum = 20.0
        chart.leftAxis.axisMinimum = 0.0
        chart.leftAxis.labelTextColor = .white
        chart.leftAxis.gridColor = .white
        chart.leftAxis.forceLabelsEnabled = true

        chart.xAxis.labelTextColor = .white
        chart.xAxis.gridColor = .white
        
        chart.borderColor = .white
        
        chart.animate(xAxisDuration: 0, yAxisDuration: 2)
        chart.doubleTapToZoomEnabled = false
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        chart.drawBordersEnabled = false
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        return chart
    }()
    
    private func setChart() {
//        guard let regionWeatherForecastModelArray = UpdatedWeatherForecastModelManager.shared.weatherForecastModels[regionalCode] else { return }
//
//        var waveHeightArray: [Double] = []
//        var windSpeedArray: [Double] = []
//        var waveChartXAxisArray: [String] = []
//        var timeArray: [Double] = []
//
//        regionWeatherForecastModelArray.forEach {
//            guard let wave = Double($0.WAV) else { return }
//            guard let wind = Double($0.WSD) else { return }
//            waveHeightArray.append(wave)
//            windSpeedArray.append(wind)
//
//            guard let modelDate = ($0.forecastDate + $0.forecastTime.prefix(2)).transferStringToFullDate() else { return }
//            let dateTimeDouble = ceil((modelDate - Date.currentTime) / 3600)
//            print(modelDate - Date.currentTime)
//            print(dateTimeDouble)
//            timeArray.append(dateTimeDouble)
//            if $0.forecastTime == "0000" {
//                var date = $0.forecastDate.suffix(4).description
//                date = date.prefix(2) + "/" + date.suffix(2)
//                waveChartXAxisArray.append(date)
//            } else {
//                let time = $0.forecastTime.prefix(2).description + "시"
//                waveChartXAxisArray.append(time)
//            }
//        }
//        chart.xAxis.labelPosition = .bottom
//        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: waveChartXAxisArray)
//        // chart data array 에 데이터 추가
//        for i in 0 ..< timeArray.count {
//            let waveChartEntry = ChartDataEntry(x: timeArray[i], y: waveHeightArray[i])
//            waveLineChartEntry.append(waveChartEntry)
//
//            let windChartEntry = ChartDataEntry(x: timeArray[i], y: windSpeedArray[i])
//            windLineChartEntry.append(windChartEntry)
//        }
//        let line1 = LineChartDataSet(entries: waveLineChartEntry, label: "파고(m)")
//        line1.colors = [NSUIColor.white]
//        line1.circleRadius = 3
//        let line2 = LineChartDataSet(entries: windLineChartEntry, label: "풍속(m/s)")
//        line2.colors = [NSUIColor.gray]
//        line2.circleRadius = 3
//
//        let data = LineChartData(dataSets: [line1, line2])
//        data.setValueTextColor(.clear)
//        chart.data = data
    }
    
    private func applySurfConditionImageLabel() {
        guard let model = UpdatedWeatherForecastModelManager.shared.weatherForecastModels[regionalCode]?.first else { return }
        let modelWaveValue = model.waveHeight
        
        setSurfConditionImageAndPercentage(wave: modelWaveValue)
    }
    
    private func applyBackground() {
        var backgroundImageName: String = "sunnyFull.png"
        guard let model = UpdatedWeatherForecastModelManager.shared.weatherForecastModels[regionalCode]?.first else { return }
        
//        switch model.SKY {
//        case "1" :
//            backgroundImageName = "sunnyFull.png"
//        case "3" :
//            backgroundImageName = "cloudyFull.png"
//        case "4":
//            backgroundImageName = "cloudyFull.png"
//        default :
//            backgroundImageName = "cloudyFull.png"
//        }
//
//        switch model.PTY {
//        case "1" :
//            backgroundImageName = "rainyFull.png"
//        case "3" :
//            backgroundImageName = "snowFull.png"
//        default :
//            break
//        }
//
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
        guard let model = UpdatedWeatherForecastModelManager.shared.weatherForecastModels[regionalCode]?.first else { return }
       
        if model.subRegionName.isEmpty {
            cityLabel.text = model.regionName
        } else { cityLabel.text = model.subRegionName}
        
        minTemperatureLabel.text = "최저: " + String(describing: model.airTemperature) + "°"
        maxTemperatureLabel.text = "최고: " + String(describing: model.airTemperature) + "°"
        temperatureLabel.text = model.airTemperature.description
        
        setWaveWindLabel(wave: model.waveHeight.description, wind: model.waveHeight.description)
    }
    
    private func setWaveWindLabel(wave: String, wind: String) {
        waveWindLabel.text = "  파고: " + wave + " m " + " 풍속: " + wind + " m/s"
    }
    
    private func setSurfConditionImageAndPercentage(wave: Double) {
        var surfImageName: String
        var surfConditionLabelText: String
        guard var surfConditionPercentage = surfConditionOutput.X1Probability[surfConditionOutput.X1] else { return }
        surfConditionPercentage = floor(surfConditionPercentage * 1000) / 10
       
        guard let surfConditionDouble = Double(surfConditionOutput.X1) else { return }
        
        switch surfConditionDouble {
        case 0:
            surfImageName = "surf1"
            if wave == 0 {
                surfConditionLabelText = "파도가 없는 지역입니다"
            } else {
                surfConditionLabelText = "파도가 약합니다"
            }
        case 1:
            surfImageName = "surf2"
            surfConditionLabelText = "입문자가 즐기기 좋습니다"
        case 2:
            surfImageName = "surf3"
            surfConditionLabelText = "초급자가 즐기기 좋습니다"
        case 3:
            surfImageName = "surf3"
            surfConditionLabelText = "중급자가 즐기기 좋습니다"
        case 4:
            surfImageName = "surf3"
            surfConditionLabelText = "상급자가 즐기기 좋습니다"
        case 5:
            surfImageName = "surf4"
            surfConditionLabelText = "서핑을 즐기기 위험합니다"
        default:
            surfImageName = "surf1"
            surfConditionLabelText = "오류"
        }
        surfImageView.image = UIImage(named: surfImageName)
        descriptionLabel.text = surfConditionLabelText
        mlPercentageLabel.text = "신뢰도: " + surfConditionPercentage.description + "%"
    }
    
    private func setSurfCondition(wave: Double, wind: Double) {
        guard let surfCondition = ML.shared.fetchPrediction(wave: wave, wind: wind) else { return }
        self.surfConditionOutput = surfCondition
    }
    
    var viewTranslation = CGPoint(x: 0, y:0)
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    private func configureConstraints() {
        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: view.bounds.height * 0.005).isActive = true
        
        degreeLabel.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor).isActive = true
        degreeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: view.bounds.height * 0.01).isActive = true
        
        tempStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempStackView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: view.bounds.height * 0.005).isActive = true
        
        surfImageView.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 10).isActive = true
        surfImageView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.25).isActive = true
        surfImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        surfImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        waveWindLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waveWindLabel.topAnchor.constraint(equalTo: surfImageView.bottomAnchor, constant: 10).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: waveWindLabel.bottomAnchor, constant: view.bounds.height * 0.002).isActive = true
        
        mlPercentageLabel.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
        mlPercentageLabel.firstBaselineAnchor.constraint(equalTo: descriptionLabel.firstBaselineAnchor).isActive = true
        mlPercentageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        chart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        chart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        chart.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        chart.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        
        weekWeatherTableView.topAnchor.constraint(equalTo: chart.bottomAnchor).isActive = true
        weekWeatherTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        weekWeatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        weekWeatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
    }
}

extension RegionWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dateArray.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeekWeatherCollectionViewHeader.reuseIdentifier, for: indexPath) as? WeekWeatherCollectionViewHeader else { return UICollectionReusableView()}
        header.dateLabel.text = dateArray[indexPath.section].transferStringToDate()?.transferDateToStringDay()
        
        return header
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionDate = dateArray[section]
        guard let dataCount = weatherForecastModels[sectionDate]?.count else {
            self.dismiss(animated: true)
            return 0
        }
        return dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = weekWeatherTableView.dequeueReusableCell(withReuseIdentifier: WeekWeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeekWeatherTableViewCell else { return UICollectionViewCell() }
        
        let sectionDate = dateArray[indexPath.section]
        guard let dayModel = weatherForecastModels[sectionDate]?[indexPath.item] else { return cell }
        cell.applyData(dayModel)
        cell.backgroundColor = .clear
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width * 0.15
        let height = collectionView.frame.height * 0.8
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.15
        let height = collectionView.frame.height * 0.8
        
        return CGSize(width: width, height: height)
    }
}

extension RegionWeatherViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let waveEntry = waveLineChartEntry.filter{ $0.x == highlight.x }
        let windEntry = windLineChartEntry.filter{ $0.x == highlight.x }
        guard let waveValue = waveEntry.first?.y else { return }
        guard let windValue = windEntry.first?.y else { return }
        
        DispatchQueue.main.async {
            self.setSurfCondition(wave: waveValue, wind: windValue)
            self.setWaveWindLabel(wave: waveValue.description, wind: windValue.description)
            self.setSurfConditionImageAndPercentage(wave: waveValue)
        }
    }
}
