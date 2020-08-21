//
//  TitleTableViewCell.swift
//  Kex
//
//  Created by Alex on 17.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //do nothing
    }

    func showType(type: PartnerConnectionType) {
        switch type {
        case .CONNECTED:
            titleLabel.text = "Ваши партнёры"
            titleLabel.isHidden = false
        case .NEW_REQUEST_FROM:
            titleLabel.text = "Новые запросы"
            titleLabel.isHidden = false
        case .WAIT_RESPONCE:
            titleLabel.text = "Ждём подтверждения"
            titleLabel.isHidden = false
        case .REJECTED:
            titleLabel.text = "Отказанные"
            titleLabel.isHidden = false
        default:
            titleLabel.isHidden = true
        }
    }
}
