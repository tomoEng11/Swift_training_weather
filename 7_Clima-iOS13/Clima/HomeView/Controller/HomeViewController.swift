//
//  HomeViewController.swift
//  Clima
//
//  Created by 井本智博 on 2024/06/30.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        print("pressed")
        let vc = CityListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
