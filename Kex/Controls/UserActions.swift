//
//  UserActions.swift
//  Kex
//
//  Created by Александр Карамышев on 12/07/2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

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

    static func isEmailValid(email: String?) -> Bool {
        if email == nil {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
