//
//  Extensions.swift
//  WeatherApp
//
//  Created by 김상현 on 2022/07/09.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
