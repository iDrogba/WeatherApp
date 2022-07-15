//
//  MainCollectionViewModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/14.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var weatherForecastModels: [String:[WeatherForecastModel]] = [:]
    
    init() {
        self.fetchWeatherForecastModels()
    }
    
    func fetchWeatherForecastModels() {
        DispatchQueue.global(qos: .userInteractive).async {
            APIRequestManager.fetchData({
                self.weatherForecastModels = WeatherForecastModelManager.shared.weatherForecastModels
                print("값 할당 done")
            })
        }
    }
}
