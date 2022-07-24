//
//  StringExtension.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/24.
//

import Foundation

extension String {
    func transferStringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

extension String {
    func transferStringToTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
