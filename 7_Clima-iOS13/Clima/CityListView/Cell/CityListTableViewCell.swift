//
//  CityListTableViewCell.swift
//  Clima
//
//  Created by 井本智博 on 2024/07/03.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class CityListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewForNext: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(cityName: String) {
        label.text = cityName
        imageViewForNext.image = UIImage(systemName: "chevron.compact.right")
    }
}
