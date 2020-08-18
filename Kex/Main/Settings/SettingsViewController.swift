//
//  SettingsViewController.swift
//  Kex
//
//  Created by Alex on 15.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onWriteDeveloperClicked(_ sender: Any) {
        UserActions.writeToDeveloper()
    }

    @IBAction func onExitClicked(_ sender: Any) {
        accountManager.removeUser()
        restartApplication()
    }

    func restartApplication() {
        children.forEach({viewController in
            viewController.dismiss(animated: false, completion: nil)
        })
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateInitialViewController()!
        UIApplication.shared.windows[0].rootViewController = mainViewController
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
