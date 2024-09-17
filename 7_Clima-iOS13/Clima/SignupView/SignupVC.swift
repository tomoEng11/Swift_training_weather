//
//  SignupVC.swift
//  Clima
//
//  Created by 井本智博 on 2024/08/31.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupVC: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // タップジェスチャーを作成
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // ビューに追加
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func emailTextField(_ sender: UITextField) {
    }

    @IBAction func passwordTextField(_ sender: UITextField) {
    }

    @IBAction func signupButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else { return }
        }
        navigationController?.popToRootViewController(animated: true)
    }
}

