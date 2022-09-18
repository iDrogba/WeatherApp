//
//  MKRegionDataModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/09/17.
//

import UIKit
import MapKit
struct MKRegionDataModel: Equatable, Codable, Hashable {
    let regionName: String
    let locality: String
    let subLocality: String
    let latitude: String
    let longitude: String
    
    init(placeMark: MKPlacemark) {
        self.regionName = placeMark.title ?? ""
        self.locality = placeMark.title ?? ""
        self.subLocality = placeMark.title ?? ""
        self.latitude = placeMark.coordinate.latitude.description
        self.longitude = placeMark.coordinate.longitude.description
    }
    
    public static func < (lhs: MKRegionDataModel, rhs: MKRegionDataModel) -> Bool{
        return lhs.regionName < rhs.regionName
    }
}

class MKRegionDataModelManager {
    static let shared = MKRegionDataModelManager()
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKey = "MKRegionDataModelKey"
    /// 메인에 추가된 지역모델들의 배열
    var addedRegionalDataModels: [MKRegionDataModel] = []

    init() { }
    
    func setSharedClass() async {
        await self.setAddedRegionalDataArray()
    }
    
    func retrieveRegionalDataModel(_ model: MKRegionDataModel) -> MKRegionDataModel? {
        guard let resultRegionalDataModel = MKRegionDataModelManager.shared.addedRegionalDataModels.firstIndex(of: model) else { return nil }
        let result = MKRegionDataModelManager.shared.addedRegionalDataModels[resultRegionalDataModel]
        return result
    }

    func retrieveSortedAddedRegionalDataModels() async -> [MKRegionDataModel] {
        async let returnVal = MKRegionDataModelManager.shared.addedRegionalDataModels.sorted(by: <)
        return await returnVal
    }
    
    /// UserDefaults에 추가된 모델들을 addedRegionalDataModels 프로퍼티에 세팅.
    func setAddedRegionalDataArray() async {
        do{
            guard let savedData = userDefaults.value(forKey: userDefaultsKey) as? Data else { return }
            let decodedData = try PropertyListDecoder().decode([MKRegionDataModel].self, from: savedData)
            self.addedRegionalDataModels = decodedData
        }catch {
            print(error)
        }
    }
    
    /// UserDefaults에 RegionModel 추가.
    func addAddedRegionalCodeAtUserDefaults(_ model: MKRegionDataModel) async {
        do{
            guard let savedData = userDefaults.value(forKey: userDefaultsKey) as? Data,
                  var decodedData = try? PropertyListDecoder().decode([MKRegionDataModel].self, from: savedData) else {
                var modelArray: [MKRegionDataModel] = []
                modelArray.append(model)
                userDefaults.set(try PropertyListEncoder().encode(modelArray), forKey: userDefaultsKey)
                return
            }
            decodedData.append(model)
            userDefaults.set(try PropertyListEncoder().encode(decodedData.uniqued()), forKey: userDefaultsKey)
        } catch {
            print(error)
        }
    }
    
    ///  UserDefaults에 RegionalCode 삭제.
    func removeAddedRegionalCodeAtUserDefaults(_ model: MKRegionDataModel) async {
        guard let savedData = userDefaults.value(forKey: userDefaultsKey) as? Data else { return }
        var decodedData = try? PropertyListDecoder().decode([MKRegionDataModel].self, from: savedData)
        guard let removeIndex = decodedData?.firstIndex(of: model) else { return }
        decodedData?.remove(at: removeIndex)
        userDefaults.set(try? PropertyListEncoder().encode(decodedData?.uniqued()), forKey: userDefaultsKey)
    }
}
