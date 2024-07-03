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
    let headerArray: [String] = [
        R.string.localizable.eu(),
        R.string.localizable.asia(),
        R.string.localizable.oceania(),
        R.string.localizable.africa()
    ]
    let euArray: [String] = [
        R.string.localizable.berlin(),
        R.string.localizable.amsterdam(),
        R.string.localizable.london()
    ]
    let asiaArray: [String] = [
        R.string.localizable.tokyo(),
        R.string.localizable.bangkok()
    ]
    let oceaniaArray: [String] = [
        R.string.localizable.sydney(),
        R.string.localizable.melbourne()
    ]
    let africaArray: [String] = [
        R.string.localizable.capetown()
    ]

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
        tableView.register(UINib(nibName: R.string.localizable.cityListId(), bundle: nil), forCellReuseIdentifier: R.string.localizable.cityListId())
        navigationItem.title = R.string.localizable.cityListTitle()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:  R.string.localizable.empty(), style:  .plain, target: nil, action: nil)
    }
}

extension CityListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CityListTableViewCell

        guard let vc = R.storyboard.cityDetailViewController.instantiateInitialViewController() else { return }

        vc.cityName = cell.label.text ?? R.string.localizable.empty()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: R.string.localizable.cityListId(), for: indexPath) as! CityListTableViewCell
        DispatchQueue.main.async {
            cell.set(cityName: self.totalArray[indexPath.section].kind[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return totalArray[section].name
    }
}

