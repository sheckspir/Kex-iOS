//
//  QuestionYouMeCell.swift
//  Kex
//
//  Created by Alex on 09.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit
import Kingfisher

class QuestionYouMeCell: UICollectionViewCell {
    
    private var questionId : Int = -1
    private var questionListener : QuestionYouMeListener? = nil
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    func showQuestion(question : Question, listener : QuestionYouMeListener) {
        self.questionId = question.id
        self.questionListener = listener
        let lastFrame = image.frame
        image.frame = CGRect(x: 0, y: 0, width: contentView.superview!.frame.width, height: lastFrame.height)
        
        let imageProcessor = MyCroppingImageProcessor(size: image.frame.size)
        if (question.image != nil) {
            print(question.image!)
            let url = URL(string: question.image!)
            image.kf.setImage(with: url, options: [.processor(imageProcessor)
                                                    ])
        } else {
            image.image = nil
        }
        
        nameLabel.text = question.title
        questionLabel.preferredMaxLayoutWidth = questionLabel.superview!.frame.width - 16
        questionLabel.text = question.question
    }
    
    @IBAction func wantDoClicked(_ sender: Any) {
        questionListener?.wantDoClicked(id: questionId)
    }
    
    @IBAction func wanttBothClicked(_ sender: Any) {
        questionListener?.wantBothClicked(id: questionId)
    }
    
    @IBAction func wantGetClicked(_ sender: Any) {
        questionListener?.wantGetClicked(id: questionId)
    }
    
    @IBAction func thinkClicked(_ sender: Any) {
        questionListener?.thinkClicked(id: questionId)
    }
    
    @IBAction func noClicked(_ sender: Any) {
        questionListener?.noClicked(id: questionId)
    }
}

protocol QuestionYouMeListener {
    func wantDoClicked(id: Int)
    func wantBothClicked(id : Int)
    func wantGetClicked(id: Int)
    func thinkClicked(id : Int)
    func noClicked(id: Int)
}
