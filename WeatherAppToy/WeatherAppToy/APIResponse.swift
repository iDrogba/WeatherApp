//
//  APIResponse.swift
//  WeatherAppToy
//
//  Created by 김상현 on 2022/06/30.
//

import Foundation

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
    let baseDate, baseTime: String
    let category: String
    let fcstDate, fcstTime, fcstValue: String
    let nx, ny: Int
}
