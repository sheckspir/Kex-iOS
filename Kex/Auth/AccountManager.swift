//
//  AccountManager.swift
//  Kex
//
//  Created by Alex on 15.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

let accountManager = AccountManager()

class AccountManager {
    
    init() {
        
    }
    
    func isHaveUser() -> Bool {
        let token = UserDefaults.standard.value(forKey: "token")
        return token != nil
    }
    
    func saveUser(login: String, token: String) {
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(login, forKey: "login")
    }
    
    func removeUser() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "login")
    }
}
