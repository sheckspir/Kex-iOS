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
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var buttonWant: UIButton!
    @IBOutlet private weak var buttonThink: UIButton!
    @IBOutlet private weak var buttonNo: UIButton!
    
    func showQuestion(question : Question) {
        let imageProcessor = MyCroppingImageProcessor(size: image.frame.size)
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
    }
}
