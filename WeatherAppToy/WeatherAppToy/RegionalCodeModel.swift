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

    static func parseStringToRegionalCodeModel(_ stringData: [String]) -> RegionalDataModel {
        let regionalDataModel = RegionalDataModel(regionalCode: stringData[0], first: stringData[1], second: stringData[2], third: stringData[3], nX: stringData[4], nY: stringData[5])

        return regionalDataModel
    }
}

class RegionalDataManager {
    static let shared = RegionalDataManager()
    var regionalDataArray: [RegionalDataModel] = []
    var regionalDataString:[[String]] = []

    init() {
        self.loadRegionalDataFromCSV()
    }

    func saveRegionalCodeAtUserDefaults(_ regionalCode: String) {
        let userDefaults = UserDefaults.standard

        userDefaults.set(regionalCode, forKey: regionalCode)
    }

    private func loadRegionalDataFromCSV() {
        guard let path = Bundle.main.path(forResource: "RegionalData", ofType: "csv") else { return }

        self.parseCSVAt(url: URL(fileURLWithPath: path))

        for index in 1 ..< regionalDataString.count - 1 {
            guard regionalDataString[index].count > 5 else { return }
            
            let regionalDataModel = RegionalDataModel.parseStringToRegionalCodeModel(regionalDataString[index])
            self.regionalDataArray.append(regionalDataModel)
        }
    }

    private func parseCSVAt(url:URL) {
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
