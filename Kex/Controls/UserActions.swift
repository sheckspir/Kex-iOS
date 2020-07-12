//
//  UserActions.swift
//  Kex
//
//  Created by Александр Карамышев on 12/07/2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class UserActions {
    
    static func writeToDeveloper() {
        let email = "sheckspir@list.ru"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}
