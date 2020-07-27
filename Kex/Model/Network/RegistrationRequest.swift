//
//  RegistrationRequest.swift
//  Kex
//
//  Created by Alex on 22.07.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class RegistrationRequest {
    
    
    init(name: String, email: String, password: String, login: String, sex: Sex) {
        self.name = name
        self.email = email
        self.password = password
        self.login = login
        self.sex = sex
    }
    
    var name: String
    var email: String
    var password: String
    var login: String
    var sex : Sex
}
