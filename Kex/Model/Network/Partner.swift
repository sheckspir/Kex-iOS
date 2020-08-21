//
//  Partner.swift
//  Kex
//
//  Created by Alex on 18.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class Partner: NSObject, Codable  {
    var id: Int
    var name: String
    var login: String
    var sex: Sex
    
    init(id: Int, name: String, login: String, sex: Sex) {
        self.id = id
        self.name = name
        self.login = login
        self.sex = sex
    }
}
