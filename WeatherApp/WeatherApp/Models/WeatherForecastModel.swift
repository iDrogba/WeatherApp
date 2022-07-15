//
//  WeatherForecastModel.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/09.
//

import Foundation

struct WeatherForecastModel {
    var regionalCode: String = ""
    var regionName: String = ""
    var nX: Int = 0
    var nY: Int = 0
    var forecastDate: String = ""
    var forecastTime: String = ""
    var POP: String = ""
    var PTY: String = ""
    var PCP: String = ""
    var REH: String = ""
    var SNO: String = ""
    var SKY: String = ""
    var TMP: String = ""
    var TMN: String = ""
    var TMX: String = ""
    var UUU: String = ""
    var VVV: String = ""
    var WAV: String = ""
    var VEC: String = ""
    var WSD: String = ""
    
    init(_ regionalCode: String, _ item: Item) {
        guard let regionalDataModel = RegionalDataManager.shared.retrieveRegionalDataModel(regionalCode) else { return }

        self.regionalCode = regionalCode
        self.regionName = regionalDataModel.second
        self.forecastDate = item.fcstDate
        self.forecastTime = item.fcstTime
        setValueByCategory(item)
    }
    
    mutating func addValueWith(_ item: Item) {
        setValueByCategory(item)
    }
    
    mutating func setValueByCategory(_ item: Item) {
        switch item.category {
        case .POP:
            self.POP = item.fcstValue
        case .PTY:
            self.PTY = item.fcstValue
        case .PCP:
            self.PCP = item.fcstValue
        case .REH:
            self.REH = item.fcstValue
        case .SNO:
            self.SNO = item.fcstValue
        case .SKY:
            self.SKY = item.fcstValue
        case .TMP:
            self.TMP = item.fcstValue
        case .TMN:
            self.TMN = item.fcstValue
        case .TMX:
            self.TMX = item.fcstValue
        case .UUU:
            self.UUU = item.fcstValue
        case .VVV:
            self.VVV = item.fcstValue
        case .WAV:
            self.WAV = item.fcstValue
        case .VEC:
            self.VEC = item.fcstValue
        case .WSD:
            self.WSD = item.fcstValue
        }
    }
}

class WeatherForecastModelManager {
    static let shared = WeatherForecastModelManager()
    /**
     행정구역을 키값으로 날씨 예보 모델을 구분한 딕셔너리.
     
     [행정구역 코드 : [날씨 예보 모델]]
     */
    var weatherForecastModels: [String:[WeatherForecastModel]] = [:]
    
    func setWeatherForecastModels(items : [Item], regionalCode: String) {
        guard weatherForecastModels[regionalCode] == nil else { return }
        self.weatherForecastModels[regionalCode] = []
        for item in items {
            let modelIndex = weatherForecastModels[regionalCode]?.firstIndex{ $0.forecastDate == item.fcstDate && $0.forecastTime == item.fcstTime }
            if let modelIndex = modelIndex {
                weatherForecastModels[regionalCode]?[modelIndex].setValueByCategory(item)
            } else {
                weatherForecastModels[regionalCode]?.append(WeatherForecastModel.init(regionalCode, item))
            }
        }
    }
}
