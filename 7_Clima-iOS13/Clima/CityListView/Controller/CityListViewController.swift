//
//  CityListViewController.swift
//  Clima
//
//  Created by 井本智博 on 2024/06/30.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let headerArray: [String] = ["EU", "アジア", "オセアニア", "アフリカ"]
    let euArray: [String] = ["ベルリン", "アムステルダム", "ロンドン"]
    let asiaArray: [String] = ["東京", "バンコク"]
    let oceaniaArray: [String] = ["シドニー", "メルボルン"]
    let africaArray: [String] = ["ケープタウン"]

    lazy var totalArray = [
        Region(isShown: true, name: headerArray[0], kind: euArray),
        Region(isShown: false, name: headerArray[1], kind: asiaArray),
        Region(isShown: false, name: headerArray[2], kind: oceaniaArray),
        Region(isShown: false, name: headerArray[3], kind: africaArray)
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityListTableViewCell", bundle: nil), forCellReuseIdentifier: "CityListTableViewCell")
        self.navigationItem.title = "都市一覧"
    }
}

extension CityListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CityListTableViewCell
        print(cell.label.text ?? "")
        let storyboard = UIStoryboard(name: "CityDetailViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CityDetailViewController") as! CityDetailViewController

        vc.cityName = cell.label.text ?? ""
        navigationController?.pushViewController(vc, animated: true)

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(headertapped(sender:)))
        headerView.addGestureRecognizer(gesture)
        headerView.tag = section
        return headerView
    }

    @objc func headertapped(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else {
            return
        }
        totalArray[section].isShown.toggle()

        tableView.beginUpdates()
        tableView.reloadSections([section], with: .automatic)
        tableView.endUpdates()
    }

}

extension CityListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalArray[section].isShown {
            return totalArray[section].kind.count
        } else {
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return totalArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell", for: indexPath) as! CityListTableViewCell
        DispatchQueue.main.async {
            cell.set(cityName: self.totalArray[indexPath.section].kind[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return totalArray[section].name
    }
}

