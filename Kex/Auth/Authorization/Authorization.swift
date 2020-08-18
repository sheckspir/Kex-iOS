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
            showError(message: "Не правильный email")
            return
        }
        if password == nil || password!.count <= 0 {
            showError(message: "Введите пароль")
            return
        }

        let provider = MoyaProvider<KexApi>()

        let loginData = LoginRequest(username: email!, password: password!)

        provider.rx.request(.login(loginRequest: loginData))
            .do(onSuccess: { result in
                self.stopLoading()
                let resultData = try result.map(RegistrationResult.self)
                UserDefaults.standard.set(resultData.access_token, forKey: "token")
                UserDefaults.standard.set(resultData.username, forKey: "login")
                self.performSegue(withIdentifier: "toMainScreen", sender: nil)
            }, onError: { error in
                self.stopLoading()
                self.showError(message: error.localizedDescription)
            }, onSubscribe: {
                self.startLoading()
                
            })
            .subscribe()
    }
    
    private func showError(message : String) {
        self.errorLabel.isHidden = false
        self.errorLabel.setNeedsDisplay()
        self.errorLabel.text = "Ошибка: " + message
    }
    
    private func startLoading() {
        self.errorLabel.isHidden = true
    }
    
    private func stopLoading() {
        
    }
}
