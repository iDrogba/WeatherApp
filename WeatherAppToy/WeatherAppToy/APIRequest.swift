//
//  DataManager.swift
//  WeatherAppToy
//
//  Created by 김상현 on 2022/06/27.
//

import Foundation
import Alamofire

class APIRequestManager {
    static func getData() async {
        var urlSets: [(RegionalDataModel,String)] = []
        for addedRegionalData in RegionalDataManager.shared.addedRegionalDataArray {
            let url = RequestInfo.shared.getURL(addedRegionalData.nX, addedRegionalData.nY)
            urlSets.append((addedRegionalData, url))
        }
        await AFRequest(urlSets)
    }
    
    static func AFRequest(_ urlSets: [(RegionalDataModel,String)]) async {
        for urlSet in urlSets {
            AF.request(urlSet.1,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseData { jsonData in
                    switch jsonData.result {
                    case .success:
                        guard let result = jsonData.data else {return}

                        do {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(APIResponse.self, from: result)
                            ShortTermForecastModelManager.shared.setShortTermForecastModelsWith(json.response.body.items.item, regionalCode: urlSet.0.regionalCode)

                        } catch {
                            print("error!\(error)")
                        }

                    default:
                        return
                    }
                    print(ShortTermForecastModelManager.shared.shortTermForecastModels)
                }
        }
        
    }
}

class RequestInfo {
    static let shared = RequestInfo()

    let baseURL: String = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?"
    let serviceKey: String = "a9yYPkQC6ZFqv%2BNOEY4%2FEldg63EPl422HBRJA2Y8Zv1euZIQ2ZKKDQx%2B%2Bo2WZObznqZL71lZ1Kgd%2FUZpJRc7Xw%3D%3D"
    let pageNo: String = "1"
    let numOfRows: String = "100"
    let dataType: String = "JSON"
    var baseDate: String = ""
    var baseTime: String = ""
    var nX: String = ""
    var nY: String = ""

    init() {
        self.setBaseDateBaseTime()
    }

    func getURL(_ nX: String, _ nY: String) -> String {
        self.nX = nX
        self.nY = nY
        var url = self.baseURL
        url += "serviceKey=" + self.serviceKey
        url += "&pageNo=" + self.pageNo
        url += "&numOfRows=" + self.numOfRows
        url += "&dataType=" + self.dataType
        url += "&base_date=" + self.baseDate
        url += "&base_time=" + self.baseTime
        url += "&nx=" + self.nX
        url += "&ny=" + self.nY
        
        return url
    }

    private func setBaseDateBaseTime() {
        let dateFormatter: DateFormatter = DateFormatter()
        let timeFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        timeFormatter.dateFormat = "HHmm"
        var currentDate: String = dateFormatter.string(from: Date())
        var currentTime: String = timeFormatter.string(from: Date())
        
        guard let IntCurrentTime = Int(currentTime) else { return }

        if IntCurrentTime > 2330 {
            currentTime = "2300"
        } else if IntCurrentTime > 2030 {
            currentTime = "2000"
        } else if IntCurrentTime > 1730 {
            currentTime = "1700"
        } else if IntCurrentTime > 1430 {
            currentTime = "1400"
        } else if IntCurrentTime > 1130 {
            currentTime = "1100"
        } else if IntCurrentTime > 830 {
            currentTime = "0800"
        } else if IntCurrentTime > 530 {
            currentTime = "0500"
        } else if IntCurrentTime > 230 {
            currentTime = "0200"
        } else {
            currentTime = "2300"
            guard let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
                return
            }
            currentDate = dateFormatter.string(from: yesterdayDate)
        }

        self.baseDate = currentDate
        self.baseTime = currentTime
    }
}
