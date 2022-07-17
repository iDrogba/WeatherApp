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
    @Published var pastWeatherForecastModels: [String:[WeatherForecastModel]] = [:]
    
    init() {
        self.fetchWeatherForecastModels()
    }
    
    func fetchWeatherForecastModels() {
        DispatchQueue.global(qos: .userInteractive).async {
            APIRequestManager.fetchData(responseType: .past, {
                self.pastWeatherForecastModels = WeatherForecastModelManager.shared.pastWeatherForecastModels
                print("과거 값 할당 done")
                APIRequestManager.fetchData(responseType: .current, {
                    self.weatherForecastModels = WeatherForecastModelManager.shared.currentWeatherForecastModels
                    print("값 할당 done")
                })
            })
        }
    }
}
