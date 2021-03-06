//
//  RegistrationViewController.swift
//  Kex
//
//  Created by Александр Карамышев on 11/07/2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Moya
import RxSwift
import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var sexSegmentControl: UISegmentedControl!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var registrationIndicator: UIActivityIndicatorView!
    @IBOutlet var registrationButton: UIButton!

    var registrationRequest: Disposable?

    override func viewDidLoad() {
        if accountManager.isHaveUser() {
            performSegue(withIdentifier: "toMainScreen", sender: nil)
        }
    }

    @IBAction func toAuthorizationClicked(_ sender: Any) {
        disposeRegistration(dispose: true)
        performSegue(withIdentifier: "toAuthorization", sender: nil)
    }

    @IBAction func registrationClicked(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        let name = nameTextField.text

        if email == nil
            || password == nil
            || email?.count == 0
            || password?.count == 0 {
            print("Не все данные заполнены")
            errorLabel.isHidden = false
            errorLabel.setNeedsDisplay()
            errorLabel.text = "Не все данные заполнены"
            return
        }
        if !UserActions.isEmailValid(email: email) {
            errorLabel.isHidden = false
            errorLabel.setNeedsDisplay()
            errorLabel.text = "Не правильный email"
            return
        }
        let sex: Sex?
        if sexSegmentControl.selectedSegmentIndex == 0 {
            sex = Sex.M
        } else if sexSegmentControl.selectedSegmentIndex == 1 {
            sex = Sex.F
        } else {
            errorLabel.isHidden = false
            errorLabel.setNeedsDisplay()
            errorLabel.text = "Пол не выбран"
            return
        }

        let logger = NetworkLoggerPlugin()
        logger.configuration.logOptions = .verbose
        let provider = MoyaProvider<KexApi>(plugins: [logger])

        let data = RegistrationRequest(name: name!, email: email!, password: password!, login: email!, sex: sex!)

        registrationRequest = provider.rx.request(.registration(registrationData: data))
            .map(RegistrationResult.self)
            .do(onSuccess: { result in
                UserDefaults.standard.set(result.access_token, forKey: "token")
                UserDefaults.standard.set(result.username, forKey: "login")
                self.disposeRegistration(dispose: false)
                self.performSegue(withIdentifier: "toMainScreen", sender: nil)
            }, onError: { error in
                self.disposeRegistration(dispose: false)
                self.errorLabel.isHidden = false
                self.errorLabel.setNeedsDisplay()
                self.errorLabel.text = "Ошибка " + error.localizedDescription
            }, onSubscribe: {
                self.registrationButton.isEnabled = false
                self.errorLabel.isHidden = true

                self.registrationIndicator.startAnimating()
                self.registrationButton.isEnabled = false
                self.emailTextField.isEnabled = false
                self.passwordTextField.isEnabled = false
                self.nameTextField.isEnabled = false
                self.sexSegmentControl.isEnabled = false
                print("onSubscribe")
            })
            .subscribe()
    }

    private func disposeRegistration(dispose: Bool) {
        if registrationRequest != nil {
            if dispose {
                registrationRequest?.dispose()
            }
            registrationRequest = nil
            registrationButton.isEnabled = true
            registrationIndicator.stopAnimating()
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            nameTextField.isEnabled = true
            sexSegmentControl.isEnabled = true
        }
    }

    @IBAction func writeToDeveloper(_ sender: Any) {
        UserActions.writeToDeveloper()
    }
}
