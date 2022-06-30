//
//  ShortTermForecastModel.swift
//  WeatherAppToy
//
//  Created by 김상현 on 2022/06/29.
//

import Foundation

struct ShortTermForecastModel {
    let regionalCode: String
    let regionName: String
    let baseDate: String
    let baseTime: String
    var temparature: String
    var rain: String
    var wave: String
    var wind: String
    var windDirection: String
}

class ShortTermForecastModelManager {
    
}

// MARK: - APIResponse
struct APIResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}

// MARK: - Body
struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let baseDate, baseTime, category, fcstDate: String
    let fcstTime, fcstValue: String
    let nx, ny: Int
}
