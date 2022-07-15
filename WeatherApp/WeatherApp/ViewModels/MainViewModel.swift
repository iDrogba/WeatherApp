//
//  MainCollectionViewModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/14.
//

import Foundation

class MainViewModel {
    static let shared = MainViewModel()
    var weatherForecastModels: Observable<[String:[WeatherForecastModel]]> = Observable([:])
    var addedRegionalDataModels: Observable<[RegionalDataModel]> = Observable([])
    init() {
        fetchAddedRegionalDataModels()
        fetchWeatherForecastModels()
        Task {
            await APIRequestManager.fetchData()
        }
    }
    
    func fetchAddedRegionalDataModels() {
        addedRegionalDataModels.value = RegionalDataManager.shared.addedRegionalDataArray
    }
    
    func fetchWeatherForecastModels() {
        weatherForecastModels.value = WeatherForecastModelManager.shared.weatherForecastModels
    }
}
