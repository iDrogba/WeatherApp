//
//  MainCollectionViewModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/14.
//

import Foundation
import Combine
import MapKit

class MainViewModel: ObservableObject {
    var regionalDataManager = UpdatedRegionalDataModelManager.shared
    var weatherForecastManager = UpdatedWeatherForecastModelManager.shared
    @Published var todayWeatherForecastModels: [String:[UpdatedWeatherForecastModel]] = [:]
    @Published var addedRegionalDataModels: [UpdatedRegionalDataModel] = []
    @Published var searchedRegionalDataModels: [UpdatedRegionalDataModel] = []
    @Published var searchCompleter = MKLocalSearchCompleter()
    @Published var searchResults = [MKLocalSearchCompletion]()
    
    init() {
        Task{
            await self.setSearchCompleter()
            await self.regionalDataManager.setSharedClass()
            await self.fetchAddedRegionalDataModels()
            await self.setWeatherForecastModels()
        }
    }
}
extension MainViewModel {
    func setSearchCompleter() async {
        searchCompleter.resultTypes = .pointOfInterest
        searchCompleter.pointOfInterestFilter = MKPointOfInterestFilter.init(including: [.beach])
    }
    
    func setSearchResults(_ result: [MKLocalSearchCompletion]) {
        self.searchResults = result
    }
    
    func searchRegionalDataModel(_ searchTerm: String) {
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
    
    func addAddedRegionalDataModel(_ regionalCode: String) async {
        await regionalDataManager.addAddedRegionalCodeAtUserDefaults(regionalCode)
        await regionalDataManager.setAddedRegionalDataArray()
        await self.fetchAddedRegionalDataModels()
    }
    func removeAddedRegionalDataModel(_ regionalCode: String) async {
        await regionalDataManager.removeAddedRegionalCodeAtUserDefaults(regionalCode)
        await regionalDataManager.setAddedRegionalDataArray()
        await self.fetchAddedRegionalDataModels()
    }
    private func fetchAddedRegionalDataModels() async {
        await self.addedRegionalDataModels = regionalDataManager.retrieveSortedAddedRegionalDataModels()
    }
    
}

extension MainViewModel {
    func setWeatherForecastModels() async {
        await APIRequestManager.fetchWeatherForecastModels()
        await self.todayWeatherForecastModels = weatherForecastManager.retrieveTodayWeatherFoercastModels()
    }
    
    func fetchWeatherForecastModel(_ regionalModel: UpdatedRegionalDataModel) async {
        await APIRequestManager.fetchWeatherForecastModel(regionalModel)
        await self.appendRegionToTodayWeatherForecastModels(regionalModel.regionalCode)
    }
    
    func appendRegionToTodayWeatherForecastModels(_ regionalCode: String) async {
        self.todayWeatherForecastModels = await weatherForecastManager.retrieveTodayWeatherFoercastModels()
    }
    
    func removeRegionFromTodayWeatherForecastModels(_ regionalCode: String) async {
        self.todayWeatherForecastModels.removeValue(forKey: regionalCode)
        await weatherForecastManager.removeWeatherForecastModels(regionalCode)
    }
}
