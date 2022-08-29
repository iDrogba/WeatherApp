//
//  CoreML.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/08/30.
//

import Foundation
import CoreML

class ML {
    static let shared = ML()
    let surfConditionModel: SurfCondition!
    
    init() {
        do {
            surfConditionModel = try SurfCondition(configuration: .init())
        } catch {
            print(error)
            surfConditionModel = nil
        }
    }
    
    func fetchPrediction(wave: Double, wind: Double) -> SurfConditionOutput? {
        do {
            let input = SurfConditionInput(WaveHeight: wave, WindSpeed: wind)
            let prediction = try surfConditionModel.prediction(input: input)
            
            return prediction
        }catch {
            print(error)
            return nil
        }
    }
}
