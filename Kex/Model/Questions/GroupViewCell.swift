//
//  GroupViewCell.swift
//  Kex
//
//  Created by Alex on 01.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class GroupViewCell: UICollectionViewCell {
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var textCountQuestionsLabelView: UILabel!
    @IBOutlet weak var nameQuestionLabelView: UILabel!
    
    
    func sendCountQuestions(answered: Int, count: Int) {
        textCountQuestionsLabelView.text = "\(answered)/\(count)"
    }
    
    func sendName(name: String) {
        nameQuestionLabelView.text = name
    }
    
    
    
    
    
}
