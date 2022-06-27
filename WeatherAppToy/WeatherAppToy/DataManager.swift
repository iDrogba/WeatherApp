//
//  DataManager.swift
//  WeatherAppToy
//
//  Created by 김상현 on 2022/06/27.
//

import Foundation
import Alamofire

class DataManager {
    static func getTest() {
            let url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=a9yYPkQC6ZFqv%2BNOEY4%2FEldg63EPl422HBRJA2Y8Zv1euZIQ2ZKKDQx%2B%2Bo2WZObznqZL71lZ1Kgd%2FUZpJRc7Xw%3D%3D&pageNo=1&numOfRows=1000&dataType=JSON&base_date=20220627&base_time=0500&nx=52&ny=30"
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    //여기서 가져온 데이터를 자유롭게 활용하세요.
                    print(json)
            }
        }
}
