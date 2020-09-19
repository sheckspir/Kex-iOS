//
//  MainTabViewController.swift
//  Kex
//
//  Created by Alex on 18/09/20.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}
