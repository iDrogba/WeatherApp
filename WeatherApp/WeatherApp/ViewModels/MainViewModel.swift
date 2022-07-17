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
    @Published var addedRegionalDataModels: [RegionalDataModel] = []
    @Published var searchedRegionalDataModels: [RegionalDataModel] = []
    var pastWeatherForecastModels: [String:[WeatherForecastModel]] = [:]
    
    init() {
        self.fetchAddedRegionalDataModels()
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
    
    func searchRegionalDataModel(_ searchTerm: String) {
        let regionalDataManager = RegionalDataManager.shared
        var retrivedRegionalData: [RegionalDataModel] = []
        
        guard searchTerm != "" else {
            searchedRegionalDataModels = retrivedRegionalData
            return
        }
        
    outer:for regionalData in regionalDataManager.regionalDataModels {
        let regionalTerm = regionalData.first + regionalData.second + regionalData.third
        inner:for searchChar in searchTerm {
            if searchChar == " " { continue inner}
            if regionalTerm.contains(searchChar) == false {
                continue outer
            }
        }
        retrivedRegionalData.append(regionalData)
    }
        searchedRegionalDataModels = retrivedRegionalData
    }
    
    func fetchAddedRegionalDataModels() {
        self.addedRegionalDataModels = RegionalDataManager.shared.addedRegionalDataModels
    }
    
    func addAddedRegionalDataModels(_ regionalCode: String) {
        RegionalDataManager.shared.addAddedRegionalCodeAtUserDefaults(regionalCode)
        RegionalDataManager.shared.setAddedRegionalDataArray()
    }
    
    func removeAddedRegionalDataModels(_ regionalCode: String) {
        RegionalDataManager.shared.removeAddedRegionalCodeAtUserDefaults(regionalCode)
        RegionalDataManager.shared.setAddedRegionalDataArray()
    }
}
