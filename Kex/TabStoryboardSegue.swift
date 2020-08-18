//
//  TabStoryboardSegue.swift
//  Kex
//
//  Created by Alex on 15.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class TabStoryboardSegue: UIStoryboardSegue {
    
    override func perform() {
        let navigationController = source.navigationController
        
//        navigationController?.popToRootViewController(animated: false)
//        navigationController?.present(destination, animated: true)
        
        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        
        navigationController?.present(vc!, animated: true)
    }

}
