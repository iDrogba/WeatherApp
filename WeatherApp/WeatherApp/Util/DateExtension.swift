//
//  DateExtension.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/24.
//

import Foundation

extension Date {
    func transferDateToKorean() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "M월 d일 E요일"
        return dateFormatter.string(from: self)
    }
    func transferTimeToKorean() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H시"
        return dateFormatter.string(from: self)
    }
    func transferTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        return dateFormatter.string(from: self)
    }
    func transferDateToStringDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    static var currentFullDate: Date {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyyMMddHH"
        let timeZoneDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        date = date.addingTimeInterval(timeZoneDifference)
        
        return date
    }
    static var currentTime: Date {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "HHmm"
        let timeZoneDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        date = date.addingTimeInterval(timeZoneDifference)
        
        return date
    }
    
}
extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
