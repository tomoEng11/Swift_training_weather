//
//  UIViewController+Extension.swift
//  Clima
//
//  Created by 井本智博 on 2024/09/16.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func dismissKeyboard() {
            // キーボードを閉じる
            view.endEditing(true)
        }
}
