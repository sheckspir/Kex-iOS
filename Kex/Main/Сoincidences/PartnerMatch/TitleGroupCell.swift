//
//  TitleGroupCell.swift
//  Kex
//
//  Created by Alex on 19.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class TitleGroupCell: UITableViewCell {

    @IBOutlet weak var titleInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // do nothing
    }
    
    func showGroup(group: QuizGroup) {
        titleInfoLabel.text = group.name
    }

}
