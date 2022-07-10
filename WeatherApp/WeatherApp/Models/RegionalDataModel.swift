//
//  RegionalDataModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/09.
//

import Foundation

struct RegionalDataModel {
    let regionalCode: String
    let first: String
    let second: String
    let third: String
    let positionX: String
    let positionY:String

    init(_ stringRegionalData: [String]) {
        self.regionalCode = stringRegionalData[0]
        self.first = stringRegionalData[1]
        self.second = stringRegionalData[2]
        self.third = stringRegionalData[3]
        self.positionX = stringRegionalData[4]
        self.positionY = stringRegionalData[5]
    }
}

class RegionalDataManager {
    static let shared = RegionalDataManager()
    let userDefaultsKey = "RegionalCode"
    let fileName = "RegionalData"
    var stringRegionalData:[[String]] = []
    var regionalDataArray: [RegionalDataModel] = []
    var selectedRegionalDataArray: [RegionalDataModel] = []

    init() {
        self.fetchSavedRegionalDataFromCSV()
        self.setSelectedRegionalDataArray()
    }

    func addSelectedRegionalCodeAtUserDefaults(_ regionalCode: String) async {
        let userDefaults = UserDefaults.standard
        var savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
        savedRegionalCodes.append(regionalCode)
        let uniquedSavedRegionalCodes = savedRegionalCodes.uniqued()

        userDefaults.set(uniquedSavedRegionalCodes, forKey: self.userDefaultsKey)
    }
    
    func setSelectedRegionalDataArray() {
        let userDefaults = UserDefaults.standard
        let savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
        
        for savedRegionalCode in savedRegionalCodes {
            let index = regionalDataArray.firstIndex{ $0.regionalCode == savedRegionalCode }
            if let index = index {
                self.selectedRegionalDataArray.append(regionalDataArray[index])
            }
        }
    }

    private func fetchSavedRegionalDataFromCSV() {
        guard let path = Bundle.main.path(forResource: self.fileName, ofType: "csv") else { return }
        self.parseCSVAt(URL(fileURLWithPath: path))

        for index in 1 ..< stringRegionalData.count - 1 {
            guard stringRegionalData[index].count > 5 else { return }
            
            let regionalDataModel = RegionalDataModel.init(stringRegionalData[index])
            self.regionalDataArray.append(regionalDataModel)
        }
    }

    private func parseCSVAt(_ url:URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArray = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArray {
                    stringRegionalData.append(item)
                }
            }
        } catch {
            print("Error reading CSV file")
        }
    }
    
}

