//
//  Question.swift
//  Kex
//
//  Created by Alex on 06.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class Question: Decodable {
    var id: Int
    var title: String
    var question: String
    var image: String? = nil
    var type: QuizType
    var hint: String
    var hintImage: String? = nil
}
