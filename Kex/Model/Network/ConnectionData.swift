//
//  ConnectionData.swift
//  Kex
//
//  Created by Alex on 19.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class ConnectionData: Decodable {
    
    let quizGroup : QuizGroup
    let questions: [Question]
    
    init(quizGroup: QuizGroup, questions: [Question]) {
        self.questions = questions
        self.quizGroup = quizGroup
    }
}
