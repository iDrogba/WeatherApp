//
//  APIRequest.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/09.
//

import Foundation
import Alamofire

class APIRequestManager {
    static func fetchData(responseType: RequestInfoType, _ completion: @escaping () -> (Void)) {
        var urlSets: [(RegionalDataModel,String)] = []
        switch responseType {
        case .current:
            for addedRegionalData in RegionalDataManager.shared.addedRegionalDataArray {
                let url = RequestInfo(responseType).fetchURL(addedRegionalData.positionX, addedRegionalData.positionY)
                urlSets.append((addedRegionalData, url))
            }
            AFRequest(responseType: responseType, urlSets){
                completion()
            }
        case .past:
            for addedRegionalData in RegionalDataManager.shared.addedRegionalDataArray {
                let url = RequestInfo(responseType).fetchURL(addedRegionalData.positionX, addedRegionalData.positionY)
                urlSets.append((addedRegionalData, url))
            }
            AFRequest(responseType: responseType, urlSets){
                completion()
            }
        }
        
    }
    
    static func AFRequest(responseType: RequestInfoType, _ urlSets: [(RegionalDataModel,String)], _ completion: @escaping () -> (Void)) {
        var loopCount: Int = 1
        
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
                        guard let result = jsonData.data else { return }

                        do {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(APIResponse.self, from: result)
                            switch responseType {
                            case .current:
                                WeatherForecastModelManager.shared.setCurrentWeatherForecastModels(items: json.response.body.items.item, regionalCode: urlSet.0.regionalCode)
                            case .past:
                                WeatherForecastModelManager.shared.setPastWeatherForecastModels(items: json.response.body.items.item, regionalCode: urlSet.0.regionalCode)
                            }
                            
                            print("atomicApiRequestDone")

                            if loopCount == urlSets.count {
                                completion()
                            }
                            loopCount += 1
                        } catch {
                            print("error!\(error)")
                        }
                    default:
                        return
                    }
                }
        }
    }
}

enum RequestInfoType {
    case current
    case past
}

class RequestInfo {
    let baseURL: String = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?"
    let serviceKey: String = "a9yYPkQC6ZFqv%2BNOEY4%2FEldg63EPl422HBRJA2Y8Zv1euZIQ2ZKKDQx%2B%2Bo2WZObznqZL71lZ1Kgd%2FUZpJRc7Xw%3D%3D"
    let pageNo: String = "1"
    var numOfRows: String = "500"
    let dataType: String = "JSON"
    var baseDate: String = ""
    var baseTime: String = ""
    var positionX: String = ""
    var positionY: String = ""

    init(_ requestInfoType: RequestInfoType) {
        switch requestInfoType {
        case .current:
            self.setBaseDateBaseTime()
        case .past:
            self.setPastBaseDateBaseTime()
        }
    }

    func fetchURL(_ nX: String, _ nY: String) -> String {
        self.positionX = nX
        self.positionY = nY
        var url = self.baseURL
        url += "serviceKey=" + self.serviceKey
        url += "&pageNo=" + self.pageNo
        url += "&numOfRows=" + self.numOfRows
        url += "&dataType=" + self.dataType
        url += "&base_date=" + self.baseDate
        url += "&base_time=" + self.baseTime
        url += "&nx=" + self.positionX
        url += "&ny=" + self.positionY
        
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
    
    private func setPastBaseDateBaseTime() {
        let dateFormatter: DateFormatter = DateFormatter()
        let timeFormatter: DateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyyMMdd"
        timeFormatter.dateFormat = "HHmm"

        var currentDate: String = dateFormatter.string(from: Date())
        var currentTime: String = timeFormatter.string(from: Date())
        guard let IntCurrentTime = Int(currentTime) else { return }

        if IntCurrentTime > 230 {
            self.baseDate = currentDate
            self.baseTime = "0200"
        } else {
            let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            currentDate = dateFormatter.string(from: yesterdayDate ?? Date())
            currentTime = "2300"
            self.baseDate = currentDate
            self.baseTime = currentTime
        }
        self.numOfRows = "266"
    }
}
