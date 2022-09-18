//
//  MainCollectionViewModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/14.
//

import Foundation
import Combine
import MapKit
import SwiftUI

class MainViewModel: ObservableObject {
    var regionalDataManager = MKRegionDataModelManager.shared
    var weatherForecastManager = UpdatedWeatherForecastModelManager.shared
    @Published var todayWeatherForecastModels: [MKRegionDataModel:[UpdatedWeatherForecastModel]] = [:]
    @Published var addedRegionalDataModels: [MKRegionDataModel] = []
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
    
    func fetchDetailRegionData(_ indexPath: IndexPath) async -> MKRegionDataModel? {
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        var result: MKRegionDataModel? = nil
        do{
            let response = try await search.start()
            let placeMark = response.mapItems[0].placemark
            result = MKRegionDataModel(placeMark: placeMark)
        }catch{
            print(error)
        }
        return result
    }
    
    func addAddedRegionalDataModel(_ model: MKRegionDataModel) async {
        await regionalDataManager.addAddedRegionalCodeAtUserDefaults(model)
        await regionalDataManager.setAddedRegionalDataArray()
        await self.fetchAddedRegionalDataModels()
    }
    func removeAddedRegionalDataModel(_ model: MKRegionDataModel) async {
        await regionalDataManager.removeAddedRegionalCodeAtUserDefaults(model)
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
    
    func fetchWeatherForecastModel(_ regionModel: MKRegionDataModel) async {
        await APIRequestManager.fetchWeatherForecastModel(regionModel)
        await self.appendRegionToTodayWeatherForecastModels(regionModel)
    }
    
    func appendRegionToTodayWeatherForecastModels(_ regionModel: MKRegionDataModel) async {
        self.todayWeatherForecastModels = await weatherForecastManager.retrieveTodayWeatherFoercastModels()
    }
    
    func removeRegionFromTodayWeatherForecastModels(_ regionModel: MKRegionDataModel) async {
        self.todayWeatherForecastModels.removeValue(forKey: regionModel)
        await weatherForecastManager.removeWeatherForecastModels(regionModel: regionModel)
    }
}
