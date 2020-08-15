//
//  AnswerSaverController.swift
//  Kex
//
//  Created by Alex on 11.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class AnswerSaverController {
    private var notSavedAnswers: [Int: [Int: QuestionAnswer]] = [:]
    var provider: MoyaProvider<KexApi>

    init() {
        provider = MoyaProvider<KexApi>()
    }

    func saveAnswer(groupId: Int, questionId: Int, answer: QuestionAnswer) {
//        todo почему-то не кодируется в текстовые поля QuestionSavingAnswer
        if notSavedAnswers[groupId] != nil {
            notSavedAnswers[groupId]![questionId] = answer
        } else {
            notSavedAnswers[groupId] = [questionId: answer]
        }
        printAllNotSaved()
        let savingAnswer = QuestionSavingAnswer(groupId: groupId, questionId: questionId, answer: answer)
        print(savingAnswer.toDict())
        _ = provider.rx.request(.sendAnswer(answer: savingAnswer))
            .asCompletable()
            .subscribe(onCompleted: {
                if self.notSavedAnswers[groupId]?[questionId] == answer {
                    self.notSavedAnswers[groupId]?.removeValue(forKey: questionId)
                }
            }, onError: { error in
                print("error happens \(error)")
            })
    }
    
    func saveAllNotSaved( onSuccess : @escaping (() -> Void), onError: @escaping ((Error) -> Void)) {
        var answers = [QuestionSavingAnswer]()
        notSavedAnswers.forEach({one in
            one.value.forEach({answer in
                answers.append(QuestionSavingAnswer(groupId : one.key, questionId: answer.key, answer: answer.value))
            })
        })
        if (answers.count == 0) {
            onSuccess()
        } else {
            _ = provider.rx.request(.sendAnswers(answers: answers))
            .asCompletable()
            .subscribe(onCompleted: {
                self.notSavedAnswers.removeAll()
                onSuccess()
            }, onError: {error in
                onError(error)
            })
        }
        
        
    }

    private func printAllNotSaved() {
        notSavedAnswers.forEach({ groups in
            let groupId = groups.key
            groups.value.forEach({ questions in
                print("group \(groupId) question \(questions.key) answer \(questions.value)")
            })
        })
    }
}
