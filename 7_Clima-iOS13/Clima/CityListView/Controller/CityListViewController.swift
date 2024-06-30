//
//  CityListViewController.swift
//  Clima
//
//  Created by 井本智博 on 2024/06/30.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
