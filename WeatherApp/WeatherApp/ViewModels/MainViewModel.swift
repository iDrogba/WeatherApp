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
        self.fetchAddedRegionalDataModels{}
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
            self.searchedRegionalDataModels = retrivedRegionalData
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
        self.searchedRegionalDataModels = retrivedRegionalData
    }
    
    func addAddedRegionalDataModels(_ regionalCode: String, _ completion: @escaping () -> Void) {
//        print(regionalCode)
//        print(RegionalDataManager.shared.addedRegionalDataModels)
        RegionalDataManager.shared.addAddedRegionalCodeAtUserDefaults(regionalCode)
        RegionalDataManager.shared.setAddedRegionalDataArray()
        self.fetchAddedRegionalDataModels{
            completion()
        }
        //TODO: 딱 한개의 요소만 네트워킹하는 로직 작성 필요
    }
    
    func removeAddedRegionalDataModels(_ regionalCode: String, _ indexAt: Int) {
        RegionalDataManager.shared.removeAddedRegionalCodeAtUserDefaults(regionalCode)
        RegionalDataManager.shared.setAddedRegionalDataArray()
        self.fetchAddedRegionalDataModels{}
//        self.addedRegionalDataModels.remove(at: indexAt)
    }
    
    func removeWeatherForecastModels(_ regionalCode: String) {
        self.weatherForecastModels.removeValue(forKey: regionalCode)
        self.pastWeatherForecastModels.removeValue(forKey: regionalCode)
        WeatherForecastModelManager.shared.removeWeatherForecastModels(regionalCode)
        print(weatherForecastModels.count)
        print(addedRegionalDataModels.count)
    }
    
    /// RegionalDataManager 로 부터 오름차순으로 가져옴.
    private func fetchAddedRegionalDataModels(_ completion: @escaping () -> Void) {
        self.addedRegionalDataModels = RegionalDataManager.shared.addedRegionalDataModels.sorted(by: <)
        completion()
    }
}
