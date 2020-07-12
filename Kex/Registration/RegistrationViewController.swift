//
//  RegistrationViewController.swift
//  Kex
//
//  Created by Александр Карамышев on 11/07/2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class RegistrationViewController : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sexSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        print("Registration loaded");
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare " + segue.description)
        
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        print("performSegue1 " + identifier)
        super.performSegue(withIdentifier: identifier, sender: sender)
        print("performSegue2 " + identifier)
    }
    
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
        } else {
            print("Все данные заполнены")
        }

        if (sexSegmentControl.selectedSegmentIndex >= 0) {
            print("Пол выбран " + sexSegmentControl.selectedSegmentIndex.description)
        } else {
            print("Пол не выбран")
        }
    }
    
    @IBAction func writeToDeveloper(_ sender: Any) {
        UserActions.writeToDeveloper()
    }
    
}
