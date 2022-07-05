//
//  ViewController.swift
//  WeatherAppToy
//
//  Created by 김상현 on 2022/06/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task{
            await RegionalDataManager.shared.addRegionalCodeAtUserDefaults("2635066000")
            await APIRequestManager.getData()
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        print(ShortTermForecastModelManager.shared.shortTermForecastModels)
    }
}

