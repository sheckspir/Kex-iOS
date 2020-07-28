
//
//  LoginRequest.swift
//  Kex
//
//  Created by Alex on 22.07.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class LoginRequest : Codable {
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    var username: String
    var password: String
}
