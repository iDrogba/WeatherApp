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
        APIRequestManager.getData()
        print(RegionalDataManager.shared.regionalDataString)
    }


}

