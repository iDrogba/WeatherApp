//
//  APIRequest.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/09.
//

import Foundation
import Alamofire

class APIRequestManager {
    static let shared = APIRequestManager()
    private let baseURL: String = "https://api.stormglass.io/v2/weather/point"
    private var parameters = ["params": "airTemperature,waveHeight,wavePeriod,waveDirection"]
    private init() { }
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.headers = ["Authorization": Storage().stormGlassAPIKey]
        return Session(configuration: configuration)
    }()
    
    static func fetchData() async {
        var regionalModels: [UpdatedRegionalDataModel] = []
        UpdatedRegionalDataModelManager.shared.addedRegionalDataModels.forEach{ regionalModels.append($0) }
        do {
            for model in regionalModels {
                shared.parameters["start"] = Date.yesterdayUTC!.timeIntervalSince1970.description
                shared.parameters["lat"] = model.latitude
                shared.parameters["lng"] = model.longitude
                let networkingResult = try await APIRequestManager.shared.requestJSON(shared.baseURL, type: NewResponse.self, method: .get, parameters: shared.parameters)
                await UpdatedWeatherForecastModelManager.shared.setCurrentWeatherForecastModels(regionalCode: model.regionalCode, hours: networkingResult.hours)
            }
        }catch{
            print(error)
        }
    }
    
    func requestJSON<T: Decodable>(_ url: String, type: T.Type, method: HTTPMethod, parameters: Parameters? = nil) async throws -> T {
        return try await session.request(url, method: method, parameters: parameters, encoding: URLEncoding.default)
            .serializingDecodable()
            .value
    }
}
