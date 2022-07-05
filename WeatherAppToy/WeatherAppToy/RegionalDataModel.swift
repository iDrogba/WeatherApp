//
//  RegionalCodeModel.swift
//  WeatherAppToy
//
//  Created by 김상현 on 2022/06/28.
//

import Foundation

struct RegionalDataModel {
    let regionalCode: String
    let first: String
    let second: String
    let third: String
    let nX: String
    let nY:String

    init(_ stringData: [String]) {
        self.regionalCode = stringData[0]
        self.first = stringData[1]
        self.second = stringData[2]
        self.third = stringData[3]
        self.nX = stringData[4]
        self.nY = stringData[5]
    }
//    static func parseStringToRegionalCodeModel(_ stringData: [String]) -> RegionalDataModel {
//        let regionalDataModel = RegionalDataModel(regionalCode: stringData[0], first: stringData[1], second: stringData[2], third: stringData[3], nX: stringData[4], nY: stringData[5])
//
//        return regionalDataModel
//    }
}

class RegionalDataManager {
    static let shared = RegionalDataManager()
    let userDefaultsKey = "RegionalCode"
    let fileName = "RegionalData"
    var regionalDataString:[[String]] = []
    var regionalDataArray: [RegionalDataModel] = []
    var addedRegionalDataArray: [RegionalDataModel] = []

    init() {
        self.loadSavedRegionalDataFromCSV()
        self.setAddedRegionalDataArray()
    }

    func addRegionalCodeAtUserDefaults(_ regionalCode: String) async {
        let userDefaults = UserDefaults.standard
        var savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
        savedRegionalCodes.append(regionalCode)
        let uniquedSavedRegionalCodes = savedRegionalCodes.uniqued()

        userDefaults.set(uniquedSavedRegionalCodes, forKey: self.userDefaultsKey)
    }
    
    func setAddedRegionalDataArray() {
        let userDefaults = UserDefaults.standard
        let savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
        
        for savedRegionalCode in savedRegionalCodes {
            let index = regionalDataArray.firstIndex{ $0.regionalCode == savedRegionalCode }
            if let index = index {
                self.addedRegionalDataArray.append(regionalDataArray[index])
            }
        }
    }

    private func loadSavedRegionalDataFromCSV() {
        guard let path = Bundle.main.path(forResource: self.fileName, ofType: "csv") else { return }
        self.parseCSVAt(URL(fileURLWithPath: path))

        for index in 1 ..< regionalDataString.count - 1 {
            guard regionalDataString[index].count > 5 else { return }
            
            let regionalDataModel = RegionalDataModel.init(regionalDataString[index])
            self.regionalDataArray.append(regionalDataModel)
        }
    }

    private func parseCSVAt(_ url:URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArray = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArray {
                    regionalDataString.append(item)
                }
            }
        } catch {
            print("Error reading CSV file")
        }
    }
    
}
