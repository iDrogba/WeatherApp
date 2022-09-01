//
//  MainCollectionViewModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/14.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var weatherForecastModels: [String:[UpdatedWeatherForecastModel]] = [:]
    @Published var addedRegionalDataModels: [UpdatedRegionalDataModel] = []
    @Published var searchedRegionalDataModels: [UpdatedRegionalDataModel] = []
    var pastWeatherForecastModels: [String:[UpdatedWeatherForecastModel]] = [:]
    
    init() {
        Task{
            await self.fetchAddedRegionalDataModels{}
            await self.fetchWeatherForecastModels()
        }
    }
    
    func fetchWeatherForecastModels() async {
        await APIRequestManager.fetchData()
        self.weatherForecastModels = UpdatedWeatherForecastModelManager.shared.weatherForecastModels
    }
    
    func searchRegionalDataModel(_ searchTerm: String) {
        let regionalDataManager = UpdatedRegionalDataModelManager.shared
        var retrivedRegionalData: [UpdatedRegionalDataModel] = []
        
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
    
    func addAddedRegionalDataModels(_ regionalCode: String, _ completion: @escaping () -> Void) async {
        UpdatedRegionalDataModelManager.shared.addAddedRegionalCodeAtUserDefaults(regionalCode)
        UpdatedRegionalDataModelManager.shared.setAddedRegionalDataArray()
        await self.fetchAddedRegionalDataModels{
            completion()
        }
        //TODO: 딱 한개의 요소만 네트워킹하는 로직 작성 필요
    }
    
    func removeAddedRegionalDataModels(_ regionalCode: String, _ indexAt: Int) {
        UpdatedRegionalDataModelManager.shared.removeAddedRegionalCodeAtUserDefaults(regionalCode)
        UpdatedRegionalDataModelManager.shared.setAddedRegionalDataArray()
        Task{
            await self.fetchAddedRegionalDataModels{}
        }
    }
    
    func removeWeatherForecastModels(_ regionalCode: String) {
        self.weatherForecastModels.removeValue(forKey: regionalCode)
        self.pastWeatherForecastModels.removeValue(forKey: regionalCode)
        UpdatedWeatherForecastModelManager.shared.removeWeatherForecastModels(regionalCode)
        print(weatherForecastModels.count)
        print(addedRegionalDataModels.count)
    }
    
    /// RegionalDataManager 로 부터 오름차순으로 가져옴.
    private func fetchAddedRegionalDataModels(_ completion: @escaping () -> Void) async {
        Task{
            self.addedRegionalDataModels = UpdatedRegionalDataModelManager.shared.addedRegionalDataModels.sorted(by: <)
            completion()
        }
    }
}
