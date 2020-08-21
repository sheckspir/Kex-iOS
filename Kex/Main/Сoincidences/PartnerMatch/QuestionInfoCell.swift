//
//  QuestionInfoCell.swift
//  Kex
//
//  Created by Alex on 19.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class QuestionInfoCell: UITableViewCell {
    @IBOutlet var questionInfoLabel: UILabel!

    private var question: Question?
    private var group: QuizGroup?
    private var listener: QuestionClickListener?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected && question != nil && listener != nil && group != nil {
            listener?.onQuestionClicked(group: group!, question: question!)
        }
    }

    func showQuestionInfo(question: Question, group : QuizGroup, listener: QuestionClickListener) {
        self.question = question
        self.group = group
        self.listener = listener
        questionInfoLabel.text = question.title
    }

}

protocol QuestionClickListener {
    func onQuestionClicked(group: QuizGroup, question: Question)
}
