//
//  LoginVC.swift
//  Clima
//
//  Created by 井本智博 on 2024/08/31.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import FirebaseAuth

final class LoginVC: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // タップジェスチャーを作成
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // ビューに追加
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.text = ""
        emailTextField.text = ""
    }

    @IBAction func signupButtonTapped(_ sender: UIButton) {
        let signupVC = SignupVC()
        navigationController?.pushViewController(signupVC, animated: true)
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {

        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let user = authResult?.user, error == nil else {
                return
            }
            guard let vc = R.storyboard.main.instantiateInitialViewController() else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


