//
//  RegionalDataModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/09.
//

import UIKit
struct UpdatedRegionalDataModel: Equatable {
    let regionalCode: String
    let regionName: String
    let first: String
    let second: String
    let third: String
    let fourth: String
    let fifth: String
    let latitude: String
    let longitude: String

    init(_ stringRegionalData: [String]) {
        self.first = stringRegionalData[0]
        self.second = stringRegionalData[1]
        self.third = stringRegionalData[2]
        self.fourth = stringRegionalData[3]
        self.fifth = stringRegionalData[4]
        self.latitude = stringRegionalData[5]
        self.longitude = stringRegionalData[6]
        self.regionalCode = stringRegionalData[7]
        self.regionName = stringRegionalData[0] + " " + stringRegionalData[1] + " " + stringRegionalData[2] + " " + stringRegionalData[3] + " " + stringRegionalData[4]
    }
    
    public static func < (lhs: UpdatedRegionalDataModel, rhs: UpdatedRegionalDataModel) -> Bool{
        return lhs.regionName < rhs.regionName
    }
}

class UpdatedRegionalDataModelManager {
    static let shared = UpdatedRegionalDataModelManager()
    let userDefaultsKey = "UpdatedRegionalCode"
    let fileName = "UpdatedRegionalData"
    var stringRegionalData:[[String]] = []
    /// 모든 지역모델들의 배열
    var regionalDataModels: [UpdatedRegionalDataModel] = []
    /// 메인에 추가된 지역모델들의 배열
    var addedRegionalDataModels: [UpdatedRegionalDataModel] = []

    init() {
        self.fetchSavedRegionalDataFromCSV()
        self.setAddedRegionalDataArray()
    }

    func retrieveRegionalDataModel(_ regionalCode: String) -> UpdatedRegionalDataModel? {
        guard let resultRegionalDataModel = regionalDataModels.filter({$0.regionalCode == regionalCode}).first else {
            return nil
        }
        return resultRegionalDataModel
    }
    
    /// UserDefaults에 추가된 모델들을 addedRegionalDataModels 프로퍼티에 세팅.
    func setAddedRegionalDataArray() {
        let userDefaults = UserDefaults.standard
        let savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
        var resultAddedRegionalDataModels: [UpdatedRegionalDataModel] = []
        for savedRegionalCode in savedRegionalCodes {
            let index = regionalDataModels.firstIndex{ $0.regionalCode == savedRegionalCode }
            if let index = index {
                resultAddedRegionalDataModels.append(regionalDataModels[index])
            }
        }
        self.addedRegionalDataModels = resultAddedRegionalDataModels
    }
    
    /// UserDefaults에 RegionalCode 추가.
    func addAddedRegionalCodeAtUserDefaults(_ regionalCode: String) {
        let userDefaults = UserDefaults.standard
        var savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
        savedRegionalCodes.append(regionalCode)
        let uniquedSavedRegionalCodes: [String] = savedRegionalCodes.uniqued()
        userDefaults.set(uniquedSavedRegionalCodes, forKey: self.userDefaultsKey)
    }
    
    ///  UserDefaults에 RegionalCode 삭제.
    func removeAddedRegionalCodeAtUserDefaults(_ regionalCode: String) {
        let userDefaults = UserDefaults.standard
        guard var savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] else { return }
        guard let indexForRemove = savedRegionalCodes.firstIndex(of: regionalCode) else { return }
        savedRegionalCodes.remove(at: indexForRemove)
        let uniquedSavedRegionalCodes: [String] = savedRegionalCodes.uniqued()

        userDefaults.set(uniquedSavedRegionalCodes, forKey: self.userDefaultsKey)
    }

    private func fetchSavedRegionalDataFromCSV() {
        guard let path = Bundle.main.path(forResource: self.fileName, ofType: "csv") else { return }
        self.parseCSVAt(URL(fileURLWithPath: path))

        for index in 1 ..< stringRegionalData.count - 1 {
            let regionalDataModel = UpdatedRegionalDataModel.init(stringRegionalData[index])
            self.regionalDataModels.append(regionalDataModel)
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
//
//struct RegionalDataModel: Equatable {
//    let regionalCode: String
//    let regionName: String
//    let first: String
//    let second: String
//    let third: String
//    let positionX: String
//    let positionY:String
//
//    init(_ stringRegionalData: [String]) {
//        self.regionalCode = stringRegionalData[0]
//        self.first = stringRegionalData[1]
//        self.second = stringRegionalData[2]
//        self.third = stringRegionalData[3]
//        self.positionX = stringRegionalData[4]
//        self.positionY = stringRegionalData[5]
//        if self.second != "" {
//            self.regionName = self.second
//        } else {
//            self.regionName = self.first
//        }
//    }
//
//    public static func < (lhs: RegionalDataModel, rhs: RegionalDataModel) -> Bool{
//        return lhs.regionName < rhs.regionName
//    }
//}
//
//class RegionalDataManager {
//    static let shared = RegionalDataManager()
//    let userDefaultsKey = "RegionalCode"
//    let fileName = "RegionalData"
//    var stringRegionalData:[[String]] = []
//    /// 모든 지역모델들의 배열
//    var regionalDataModels: [RegionalDataModel] = []
//    /// 메인에 추가된 지역모델들의 배열
//    var addedRegionalDataModels: [RegionalDataModel] = []
//
//    init() {
//        self.fetchSavedRegionalDataFromCSV()
//        self.setAddedRegionalDataArray()
//    }
//
//    func retrieveRegionalDataModel(_ regionalCode: String) -> RegionalDataModel? {
//        guard let resultRegionalDataModel = regionalDataModels.filter({$0.regionalCode == regionalCode}).first else {
//            return nil
//        }
//        return resultRegionalDataModel
//    }
//
//    /// UserDefaults에 추가된 모델들을 addedRegionalDataModels 프로퍼티에 세팅.
//    func setAddedRegionalDataArray() {
//        let userDefaults = UserDefaults.standard
//        let savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
//        var resultAddedRegionalDataModels: [RegionalDataModel] = []
//        for savedRegionalCode in savedRegionalCodes {
//            let index = regionalDataModels.firstIndex{ $0.regionalCode == savedRegionalCode }
//            if let index = index {
//                resultAddedRegionalDataModels.append(regionalDataModels[index])
//            }
//        }
//        self.addedRegionalDataModels = resultAddedRegionalDataModels
//    }
//
//    /// UserDefaults에 RegionalCode 추가.
//    func addAddedRegionalCodeAtUserDefaults(_ regionalCode: String) {
//        let userDefaults = UserDefaults.standard
//        var savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
//        savedRegionalCodes.append(regionalCode)
//        let uniquedSavedRegionalCodes: [String] = savedRegionalCodes.uniqued()
//        userDefaults.set(uniquedSavedRegionalCodes, forKey: self.userDefaultsKey)
//    }
//
//    ///  UserDefaults에 RegionalCode 삭제.
//    func removeAddedRegionalCodeAtUserDefaults(_ regionalCode: String) {
//        let userDefaults = UserDefaults.standard
//        guard var savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] else { return }
//        guard let indexForRemove = savedRegionalCodes.firstIndex(of: regionalCode) else { return }
//        savedRegionalCodes.remove(at: indexForRemove)
//        let uniquedSavedRegionalCodes: [String] = savedRegionalCodes.uniqued()
//
//        userDefaults.set(uniquedSavedRegionalCodes, forKey: self.userDefaultsKey)
//    }
//
//    private func fetchSavedRegionalDataFromCSV() {
//        guard let path = Bundle.main.path(forResource: self.fileName, ofType: "csv") else { return }
//        self.parseCSVAt(URL(fileURLWithPath: path))
//
//        for index in 1 ..< stringRegionalData.count - 1 {
//            guard stringRegionalData[index].count > 5 else { return }
//
//            let regionalDataModel = RegionalDataModel.init(stringRegionalData[index])
//            self.regionalDataModels.append(regionalDataModel)
//        }
//    }
//
//    private func parseCSVAt(_ url:URL) {
//        do {
//            let data = try Data(contentsOf: url)
//            let dataEncoded = String(data: data, encoding: .utf8)
//
//            if let dataArray = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
//                for item in dataArray {
//                    stringRegionalData.append(item)
//                }
//            }
//        } catch {
//            print("Error reading CSV file")
//        }
//    }
//}
//
