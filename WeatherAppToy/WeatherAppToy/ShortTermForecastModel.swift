//
//  ShortTermForecastModel.swift
//  WeatherAppToy
//
//  Created by 김상현 on 2022/06/29.
//

import Foundation

struct ShortTermForecastModel {
    let regionalCode: String
    let regionName: String = ""
    let nX: String = ""
    let nY: String = ""
    let forecastDate: String = ""
    let forecastTime: String = ""
    var temparature: String = ""
    var rain: String = ""
    var wave: String = ""
    var wind: String = ""
    var windDirection: String = ""
}

class ShortTermForecastModelManager {
    static let shared = ShortTermForecastModelManager()
    var shortTermForecastArray: [ShortTermForecastModel] = []
    
    func setShortTermForecastArrayWith(_ item : [Item], regionalCode: String) {
        for item in item {
            
        }
    }
}
