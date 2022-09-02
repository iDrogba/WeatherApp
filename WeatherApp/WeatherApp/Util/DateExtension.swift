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
    static var dateA: Date {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let timeZoneDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        date = date.addingTimeInterval(timeZoneDifference)
        
        return date
    }
    
    static var dateB: Date {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyyMMddHH"
        let timeZoneDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        date = date.addingTimeInterval(timeZoneDifference)
        
        return date
    }
    
    static var dateC: Date {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyyMMdd"
        let timeZoneDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        date = date.addingTimeInterval(timeZoneDifference)
        
        return date
    }
    
    //현지가 00시일때의 UTC 구하기
    static var yesterdayUTC: Date? {
        let date = Date()
        let midnight = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let dateCom = DateComponents(timeZone: TimeZone(identifier: "UTC"), year: midnight.year, month: midnight.month, day: midnight.day, hour: 0, minute: 0)
        let timeZoneDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        let resultDate = Calendar.current.date(from: dateCom)?.addingTimeInterval(-timeZoneDifference)
        return resultDate
    }
    
    static var currentTime: Date {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
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
