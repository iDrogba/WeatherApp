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
    private let userDefaultsKey = "UpdatedRegionalCode"
    private let fileName = "UpdatedRegionalData"
    var stringRegionalData:[[String]] = []
    /// 모든 지역모델들의 배열
    var regionalDataModels: [UpdatedRegionalDataModel] = []
    /// 메인에 추가된 지역모델들의 배열
    var addedRegionalDataModels: [UpdatedRegionalDataModel] = []

    init() { }
    
    func setSharedClass() async {
        await self.fetchSavedRegionalDataFromCSV()
        await self.setAddedRegionalDataArray()
    }

    func retrieveSortedAddedRegionalDataModels() async -> [UpdatedRegionalDataModel] {
        async let returnVal = UpdatedRegionalDataModelManager.shared.addedRegionalDataModels.sorted(by: <)
        return await returnVal
    }
    
    func retrieveRegionalDataModel(_ regionalCode: String) -> UpdatedRegionalDataModel? {
        guard let resultRegionalDataModel = regionalDataModels.filter({$0.regionalCode == regionalCode}).first else {
            return nil
        }
        return resultRegionalDataModel
    }
    
    /// UserDefaults에 추가된 모델들을 addedRegionalDataModels 프로퍼티에 세팅.
    func setAddedRegionalDataArray() async {
        var resultAddedRegionalDataModels: [UpdatedRegionalDataModel] = []
        async let savedRegionalCodes = UserDefaults.standard.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
        for savedRegionalCode in await savedRegionalCodes {
            async let index = regionalDataModels.firstIndex{ $0.regionalCode == savedRegionalCode }
            if let index = await index {
                resultAddedRegionalDataModels.append(regionalDataModels[index])
            }
        }
        self.addedRegionalDataModels = resultAddedRegionalDataModels
    }
    
    /// UserDefaults에 RegionalCode 추가.
    func addAddedRegionalCodeAtUserDefaults(_ regionalCode: String) async {
        let userDefaults = UserDefaults.standard
        var savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] ?? [String]()
        savedRegionalCodes.append(regionalCode)
        let uniquedSavedRegionalCodes: [String] = savedRegionalCodes.uniqued()
        userDefaults.set(uniquedSavedRegionalCodes, forKey: self.userDefaultsKey)
    }
    
    ///  UserDefaults에 RegionalCode 삭제.
    func removeAddedRegionalCodeAtUserDefaults(_ regionalCode: String) async {
        let userDefaults = UserDefaults.standard
        guard var savedRegionalCodes = userDefaults.array(forKey: self.userDefaultsKey) as? [String] else { return }
        guard let indexForRemove = savedRegionalCodes.firstIndex(of: regionalCode) else { return }
        savedRegionalCodes.remove(at: indexForRemove)
        
        let uniquedSavedRegionalCodes: [String] = savedRegionalCodes.uniqued()
        userDefaults.set(uniquedSavedRegionalCodes, forKey: self.userDefaultsKey)
    }

    private func fetchSavedRegionalDataFromCSV() async {
        guard let path = Bundle.main.path(forResource: self.fileName, ofType: "csv") else { return }
        let stringData = await self.parseCSVAt(URL(fileURLWithPath: path))
        await self.appendStringDataToRegionalDataModels(stringData)
    }

    private func parseCSVAt(_ url:URL) async -> [[String]] {
        do {
            async let mappedDataArray = String(data: Data(contentsOf: url), encoding: .utf8)!.components(separatedBy: "\n").map({$0.components(separatedBy: ",")})
            return try await mappedDataArray
        } catch {
            print("Error reading CSV file")
        }
        return [[]]
    }

    private func appendStringDataToRegionalDataModels(_ stringData: [[String]]) async {
        for index in 1 ..< stringData.count - 1 {
            async let regionalDataModel = UpdatedRegionalDataModel.init(stringData[index])
            await self.regionalDataModels.append(regionalDataModel)
        }
    }
}
