//
//  File.swift
//  Kex
//
//  Created by Alex on 11.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class QuestionSavingAnswer: Codable  {
    
    var groupId: String
    var questionId: String
    var answer1: QuestionAnswer
    
    
    init(groupId: Int, questionId : Int, answer: QuestionAnswer) {
        self.groupId = String(groupId)
        self.questionId = String(questionId)
        self.answer1 = answer
    }
    
}
