//
//  Offer.swift
//  Kex
//
//  Created by Alex on 20.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class Offer : Decodable{
    let text : String
    
    init(text: String) {
        self.text = text
    }
}
