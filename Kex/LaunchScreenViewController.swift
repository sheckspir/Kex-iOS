//
//  LaunchScreenViewController.swift
//  Kex
//
//  Created by Alex on 15.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if (accountManager.isHaveUser()) {
            performSegue(withIdentifier: "toTab", sender: nil)
        } else {
            performSegue(withIdentifier: "toAuth", sender: nil)
        }
        // Do any additional setup after loading the view.
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
