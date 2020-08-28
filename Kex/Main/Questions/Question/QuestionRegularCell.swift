//
//  QuestionRegularCell.swift
//  Kex
//
//  Created by Alex on 09.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit
import Kingfisher
import Nuke

class QuestionRegularCell: UICollectionViewCell {
    
    var questionIndex = -1
    var questionListener : QuestionRegularListener? = nil
    
    @IBOutlet private weak var image: UIImageView!
 
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    func showQuestion(question : Question, listener: QuestionRegularListener) {
        questionIndex = question.id
        questionListener = listener
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
