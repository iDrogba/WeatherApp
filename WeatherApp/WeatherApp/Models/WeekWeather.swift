//
//  WeekWeather.swift
//  WeatherApp
//
//  Created by Lena on 2022/07/11.
//

import Foundation

struct WeekWeather {
    var day: String
    var minTemperature: String
    var maxTemperature: String
    var weatherImageName: String
}


/// dummy data
var weekWeather: [WeekWeather] =
[WeekWeather(day: "Monday", minTemperature: "24", maxTemperature: "32", weatherImageName: "sun.min"),
 WeekWeather(day: "Tuesday", minTemperature: "18", maxTemperature: "28", weatherImageName: "sun.max"),
 WeekWeather(day: "Wednesday", minTemperature: "27", maxTemperature: "34", weatherImageName: "sun.max"),
 WeekWeather(day: "Thursday", minTemperature: "29", maxTemperature: "36", weatherImageName: "sun.max"),
 WeekWeather(day: "Friday", minTemperature: "21", maxTemperature: "26", weatherImageName: "cloud.rain"),
 WeekWeather(day: "Saturday", minTemperature: "25", maxTemperature: "30", weatherImageName: "cloud"),
 WeekWeather(day: "Sunday", minTemperature: "28", maxTemperature: "36", weatherImageName: "sun.max")
]
