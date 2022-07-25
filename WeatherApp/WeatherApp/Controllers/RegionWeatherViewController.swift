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
    private var weatherForecastModels: [String:[WeatherForecastModel]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let forecastDateArray = WeatherForecastModelManager.shared.currentWeatherForecastModels[regionalCode]
        forecastDateArray?.forEach{
            if weatherForecastModels[$0.forecastDate] == nil {
                weatherForecastModels.updateValue([$0], forKey: $0.forecastDate)
            } else {
                weatherForecastModels[$0.forecastDate]?.append($0)
            }
            
        }
        dateArray = weatherForecastModels.keys.sorted(by: <)
        
        
        [cityLabel, temperatureLabel, degreeLabel, tempStackView, descriptionLabel, surfImageView, waveHeightLabel, weekWeatherTableView, chart].forEach {
            view.addSubview($0)
        }
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        weekWeatherTableView.separatorStyle = .none
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self

        DispatchQueue.main.async {
            self.configureConstraints()
            self.applyData()
            self.applyBackground()
            self.applySurfImage()
            self.setChart()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            
        }
    }
    
    private func setChart() {
        guard let regionWeatherForecastModelArray = WeatherForecastModelManager.shared.currentWeatherForecastModels[regionalCode] else { return }
        guard let baseDate = Double(regionWeatherForecastModelArray.first?.forecastDate ?? "0") else { return }
        var lineChartEntry = [ChartDataEntry]() // graph 에 보여줄 data array
        var waveHeightArray: [Double] = []
        var timeArray: [Double] = []
        var xAxisArray: [String] = []
        regionWeatherForecastModelArray.forEach{
            guard let wave = Double($0.WAV) else { return }
            guard var dateTime = Double($0.forecastTime.prefix(2)) else { return }
            guard let modelDate = Double($0.forecastDate) else { return }
            dateTime = dateTime + (modelDate - baseDate) * 24
            waveHeightArray.append(wave)
            timeArray.append(dateTime)
            if $0.forecastTime == "0000" {
                let date = String($0.forecastDate.suffix(4))
                xAxisArray.append(date)
            } else {
                let time = String($0.forecastTime.prefix(2)) + "시"
                xAxisArray.append(time)
            }
        }
        
        // chart data array 에 데이터 추가
        for i in 0 ..< timeArray.count {
            let value = ChartDataEntry(x: timeArray[i], y: waveHeightArray[i])
            
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "파고(m)")
        line1.colors = [NSUIColor.white]
        line1.circleRadius = 3
        let data = LineChartData(dataSet: line1)
        data.setValueTextColor(.clear)
        chart.data = data
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisArray)
    }
    
    /// RegionWeatherView : 주간 날씨 테이블뷰
    private var weekWeatherTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.register(WeekWeatherTableViewCell.self, forCellReuseIdentifier: WeekWeatherTableViewCell.reuseIdentifier)
        tableView.backgroundColor = transparentBackground
        tableView.showsVerticalScrollIndicator = false
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
    
    private var waveHeightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.frame = CGRect()
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.shadowColor = customShadow
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var chart: LineChartView = {
        let chart  = LineChartView()
        let xScale = 6.0
        let yScale = 2.0
        chart.zoom(scaleX: xScale, scaleY: yScale, x: 0, y: 0)
        chart.rightAxis.enabled = false
        chart.animate(xAxisDuration: 0, yAxisDuration: 1.5)
        chart.leftAxis.axisMaximum = 2.5
        chart.leftAxis.axisMinimum = 0.0
        chart.borderColor = .white
        chart.rightAxis.labelTextColor = .white
        chart.leftAxis.labelTextColor = .white
        chart.xAxis.labelTextColor = .white
        chart.xAxis.gridColor = .white
        chart.rightAxis.gridColor = .white
        chart.leftAxis.gridColor = .white
        chart.borderColor = .white
        chart.doubleTapToZoomEnabled = false
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        chart.drawBordersEnabled = false
        chart.leftAxis.forceLabelsEnabled = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        return chart
    }()
    
    private func applySurfImage() {
        var surfImageName: String
        guard let model = WeatherForecastModelManager.shared.currentWeatherForecastModels[regionalCode]?.first else { return }
        
        guard let modelWaveValue = Double(model.WAV) else { return }
        if modelWaveValue >= 2 { // 높은 파도
            surfImageName = "surf4"
        } else if modelWaveValue >= 1 { // 서핑하기 좋음
            surfImageName = "surf3"
        } else if modelWaveValue >= 0.5 { // 초심자에게 좋음
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
        guard let pastTMXModel = WeatherForecastModelManager.shared.pastWeatherForecastModels[regionalCode]?.filter({ $0.forecastTime == "1500" }).first else { return }
        guard let pastTMMModel = WeatherForecastModelManager.shared.pastWeatherForecastModels[regionalCode]?.filter({ $0.forecastTime == "0600" }).first else { return }
        
        var descriptionLabelText: String
        
        guard let modelWaveValue = Double(model.WAV) else { return }
        if modelWaveValue >= 2 {
            descriptionLabelText = "파도가 높습니다"
        } else if modelWaveValue >= 1 {
            descriptionLabelText = "서핑을 즐기기 좋습니다"
        } else if modelWaveValue >= 0.5 {
            descriptionLabelText = "초심자가 즐기기 좋습니다"
        } else if modelWaveValue == 0 {
            descriptionLabelText = "파도가 없거나 약한 지역입니다"
            waveHeightLabel.text = ""
        } else {
            descriptionLabelText = "파도가 약합니다"
        }
        
        if model.subRegionName.isEmpty {
            cityLabel.text = model.regionName
        } else { cityLabel.text = model.subRegionName}
        let TMX = Int(round(Double(pastTMXModel.TMX) ?? 0))
        let TMN = Int(round(Double(pastTMMModel.TMN) ?? 0))
        
        minTemperatureLabel.text = "최저: " + String(describing: TMN) + "°"
        maxTemperatureLabel.text = "최고: " + String(describing: TMX) + "°"
        temperatureLabel.text = model.TMP
        descriptionLabel.text = descriptionLabelText
        waveHeightLabel.text = model.WAV + "m"
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
        surfImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        surfImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        surfImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: surfImageView.bottomAnchor, constant: 10).isActive = true
        
        waveHeightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waveHeightLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: view.bounds.height * 0.002).isActive = true
        
        chart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        chart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        chart.topAnchor.constraint(equalTo: waveHeightLabel.bottomAnchor).isActive = true
        chart.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15).isActive = true
        
        weekWeatherTableView.topAnchor.constraint(equalTo: chart.bottomAnchor, constant: view.bounds.height * 0.02).isActive = true
        weekWeatherTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        weekWeatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        weekWeatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
    }
}

extension RegionWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dateArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = dateArray[section].transferStringToDate()?.transferDateToString()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.textColor = .white
        
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDate = dateArray[section]
        guard let dataCount = weatherForecastModels[sectionDate]?.count else {
            self.dismiss(animated: true)
            return 0
        }
        
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: WeekWeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeekWeatherTableViewCell else { return UITableViewCell() }
        
        let sectionDate = dateArray[indexPath.section]
        guard let dayModel = weatherForecastModels[sectionDate]?[indexPath.row] else { return cell }
        cell.applyData(dayModel)
        cell.backgroundColor = .clear
        
        return cell
    }
}
