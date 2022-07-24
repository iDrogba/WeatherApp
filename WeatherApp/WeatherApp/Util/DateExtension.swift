//
//  DateExtension.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/24.
//

import Foundation

extension Date {
    func transferDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "M월 d일 E요일"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    func transferDateToStringDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    func transferTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H시"
        return dateFormatter.string(from: self)
    }
}
