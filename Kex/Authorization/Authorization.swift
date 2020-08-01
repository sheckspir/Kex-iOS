//
//  Authorization.swift
//  Kex
//
//  Created by Александр Карамышев on 11/07/2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Moya
import UIKit

class Authorization: UIViewController {
    @IBOutlet var emailEditText: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!

    @IBAction func onLoginClicked(_ sender: Any) {
        let email = emailEditText.text
        let password = passwordTextField.text
        if !UserActions.isEmailValid(email: email) {
            errorLabel.isHidden = false
            errorLabel.setNeedsDisplay()
            errorLabel.text = "Не правильный email"
            return
        }
        if password == nil || password!.count <= 0 {
            errorLabel.isHidden = false
            errorLabel.setNeedsDisplay()
            errorLabel.text = "Введите пароль"
            return
        }

        let provider = MoyaProvider<KexApi>()

        let loginData = LoginRequest(username: email!, password: password!)

        provider.rx.request(.login(loginRequest: loginData))
            .do(onSuccess: { result in
                let resultData = try result.map(RegistrationResult.self)
                UserDefaults.standard.set(resultData.access_token, forKey: "token")
                UserDefaults.standard.set(resultData.username, forKey: "login")
                self.performSegue(withIdentifier: "toMainScreen", sender: nil)
            }, onError: { error in
                self.errorLabel.isHidden = false
                self.errorLabel.setNeedsDisplay()
                self.errorLabel.text = "Ошибка: " + error.localizedDescription
            }, onSubscribe: {
                self.errorLabel.isHidden = true
            })
            .subscribe()
    }
}
