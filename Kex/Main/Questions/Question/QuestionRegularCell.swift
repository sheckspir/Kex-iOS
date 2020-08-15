//
//  QuestionRegularCell.swift
//  Kex
//
//  Created by Alex on 09.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit
import Kingfisher

class QuestionRegularCell: UICollectionViewCell {
    
    var questionIndex = -1
    var questionListener : QuestionRegularListener? = nil
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    func showQuestion(question : Question, listener: QuestionRegularListener) {
        let minimumQuestionSize = questionLabel.font.lineHeight * 3
        let imageProcessor = MyCroppingImageProcessor(size: image.frame.size)
        questionIndex = question.id
        questionListener = listener
        if (question.image != nil) {
            print(question.image!)
            let url = URL(string: question.image!)
            image.kf.setImage(with: url, options: [.processor(imageProcessor),
                                                   .forceRefresh])
        } else {
            image.image = nil
        }
        
        nameLabel.text = question.title
        questionLabel.preferredMaxLayoutWidth = questionLabel.superview!.frame.width - 16
        questionLabel.text = question.question
        print("height = \(questionLabel.frame.size.height) min: \(minimumQuestionSize)")
//        if (questionLabel.bounds.height < minimumQuestionSize) {
//            let oldBounds = questionLabel.bounds
//            questionLabel.frame = CGRect(x: 0, y: 0, width: oldBounds.width, height: minimumQuestionSize)
//            questionLabel.fit
//        }
        
        if (questionLabel.frame.size.height < minimumQuestionSize) {
//            let oldFrame = questionLabel.frame
            questionLabel.frame.size.height = minimumQuestionSize
            questionLabel.layoutIfNeeded()
//            questionLabel.frame = CGRect(x: 0, y: 0, width: oldFrame.width, height: minimumQuestionSize)
        }
    }
    
    @IBAction func wantClicked(_ sender: Any) {
        questionListener?.wantClicked(id: questionIndex)
    }
    
    @IBAction func thinkClicked(_ sender: Any) {
        questionListener?.thinkClicked(id: questionIndex)
    }
    
    
    @IBAction func noClicked(_ sender: Any) {
        questionListener?.noClicked(id: questionIndex)
    }
}

protocol QuestionRegularListener {
    func wantClicked(id : Int)
    func thinkClicked(id : Int)
    func noClicked(id: Int)
}
