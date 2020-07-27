//
//  RegistrationViewController.swift
//  Kex
//
//  Created by Александр Карамышев on 11/07/2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class RegistrationViewController : UIViewController {
   
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var sexSegmentControl: UISegmentedControl!
   @IBOutlet weak var errorLabel: UILabel!

   @IBAction func toAuthorizationClicked(_ sender: Any) {
      performSegue(withIdentifier: "toAuthorization", sender: nil)
   }
   
   @IBAction func registrationClicked(_ sender: Any) {
      let email = emailTextField.text
      let password = passwordTextField.text
      let name = nameTextField.text
      
      if (email == nil
         || password == nil
         || email?.count == 0
         || password?.count == 0) {
         print("Не все данные заполнены")
         errorLabel.isHidden = false
         errorLabel.setNeedsDisplay()
         errorLabel.text = "Не все данные заполнены"
         return
      }
      if (!UserActions.isEmailValid(email: email)) {
         errorLabel.isHidden = false
         errorLabel.setNeedsDisplay()
         errorLabel.text = "Не правильный email"
         return
      }
      let sex : Sex?
      if (sexSegmentControl.selectedSegmentIndex == 0) {
         sex = Sex.M
      } else if (sexSegmentControl.selectedSegmentIndex == 1) {
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
   
      
      let disposable = provider.rx.request(.registration(registrationData: data))
         .map(RegistrationResult.self)
         .do(onSuccess: {result in
            UserDefaults.standard.set(result.access_token, forKey: "token")
            UserDefaults.standard.set(result.username, forKey: "login")
            self.performSegue(withIdentifier: "toMainScreen", sender: nil)
         }, onError: {error in
            self.errorLabel.isHidden = false
            self.errorLabel.setNeedsDisplay()
            self.errorLabel.text = "Ошибка " + error.localizedDescription
         }, onSubscribe: {
            self.errorLabel.isHidden = true
            print("onSubscribe")
         })
      .subscribe()
   }
   
   @IBAction func writeToDeveloper(_ sender: Any) {
      UserActions.writeToDeveloper()
   }
   
}
