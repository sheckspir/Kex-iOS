//
//  QuestionYouMeCell.swift
//  Kex
//
//  Created by Alex on 09.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class QuestionYouMeCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var wantGetButton: UIButton!
    @IBOutlet weak var wantBothButton: UIButton!
    @IBOutlet weak var wantDoButton: UIButton!
    @IBOutlet weak var thinkButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
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
