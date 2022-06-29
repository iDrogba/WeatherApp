//
//  ShortTermForecastModel.swift
//  WeatherAppToy
//
//  Created by 김상현 on 2022/06/29.
//

import Foundation

struct ShortTermForecastNetworkingModel: Codable {
    let baseDate: String
    let baseTime: String
    let category: ShortTermForecastNetworkingCategory
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: String
    let ny: String
}

enum ShortTermForecastNetworkingCategory: Codable {
    case POP, PTY, PCP, REH, SNO, SKY, TMP, TMN, TMX, UUU, VVV, WAV, VEC, WSD
}

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
