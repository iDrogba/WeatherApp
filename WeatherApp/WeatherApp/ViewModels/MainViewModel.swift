//
//  MainCollectionViewModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/14.
//

import Foundation

class MainCollectionViewModel {
    static let shared = MainCollectionViewModel()
    var weatherForecastModel: Observable<[String:[WeatherForecastModel]]> = Observable([:])
    
    init() {
        Task {
            await APIRequestManager.fetchData()
        }
    }
    
    func fetchWeatherForecastModel() {
        weatherForecastModel.value = WeatherForecastModelManager.shared.weatherForecastModels
    }
}
