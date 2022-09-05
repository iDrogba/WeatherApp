//
//  APIResponse.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/09.
//

import Foundation

//// MARK: - APIResponse
//struct APIResponse: Codable {
//    let response: Response
//}
//
//// MARK: - Response
//struct Response: Codable {
//    let header: Header
//    let body: Body
//}
//
//// MARK: - Header
//struct Header: Codable {
//    let resultCode, resultMsg: String
//}
//
//// MARK: - Body
//struct Body: Codable {
//    let dataType: String
//    let items: Items
//    let pageNo, numOfRows, totalCount: Int
//}
//
//// MARK: - Items
//struct Items: Codable {
//    let item: [Item]
//}
//
//// MARK: - Item
//struct Item: Codable {
//    let baseDate, baseTime: String
//    let category: Category
//    let fcstDate, fcstTime, fcstValue: String
//    let nx, ny: Int
//}
//
//enum Category: String, Codable {
//    case POP, PTY, PCP, REH, SNO, SKY, TMP, TMN, TMX, UUU, VVV, WAV, VEC, WSD
//}


struct NewResponse: Codable {
    let hours: [Hours]
    let meta: Meta
}

struct Hours: Codable {
    let time: String
    let airTemperature, waveHeight, wavePeriod, waveDirection, windSpeed, cloudCover, precipitation, snowDepth: [String: Double]?
}

struct Meta: Codable {
    let dailyQuota: Double
    let lat: Double
    let lng: Double
    let requestCount: Double
}
