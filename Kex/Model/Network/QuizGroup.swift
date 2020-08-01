//
//  QuizGroup.swift
//  Kex
//
//  Created by Alex on 28.07.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class QuizGroup: Decodable {
    var id: Int
    var name : String
    var imageUrl: String
    var count: Int
    var answered: Int
}
