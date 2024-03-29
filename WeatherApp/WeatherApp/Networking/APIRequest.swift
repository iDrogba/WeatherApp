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
    private var parameters = ["params": "airTemperature,waveHeight,wavePeriod,waveDirection,windSpeed,cloudCover,precipitation,snowDepth"]
    private init() { }
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.headers = ["Authorization": Storage().stormGlassAPIKey]
        return Session(configuration: configuration)
    }()
    
    static func fetchWeatherForecastModels() async {
        async let regionalModels = MKRegionDataModelManager.shared.addedRegionalDataModels
        for model in await regionalModels {
            await fetchWeatherForecastModel(model)
        }
    }
    
    static func fetchWeatherForecastModel(_ regionModel: MKRegionDataModel) async {
        do {
            shared.parameters["start"] = Date.yesterdayUTC!.timeIntervalSince1970.description
            shared.parameters["lat"] = regionModel.latitude
            shared.parameters["lng"] = regionModel.longitude
            let networkingResult = try await APIRequestManager.shared.requestJSON(shared.baseURL, type: NewResponse.self, method: .get, parameters: shared.parameters)
            await UpdatedWeatherForecastModelManager.shared.appendCurrentWeatherForecastModels(regionModel: regionModel, hours: networkingResult.hours)
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
