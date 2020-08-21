//
//  PartnelConfirmableCell.swift
//  Kex
//
//  Created by Alex on 17.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class PartnelConfirmableCell: UITableViewCell {

    @IBOutlet weak var userLoginLabel: UILabel!
    
    private var partner: Partner? = nil
    private var listener : PartnerConfirmListener? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //do nothing
    }

    @IBAction func onRefuseClicked(_ sender: Any) {
        if (partner != nil && listener != nil) {
            listener?.onPartnerReject(partner: partner!)
        }
    }
    
    @IBAction func onConfirmClicked(_ sender: Any) {
        if (partner != nil && listener != nil) {
            listener?.onPartnerConfirm(partner: partner!)
        }
    }
    
    func showPartner(partner: Partner, listener: PartnerConfirmListener) {
        self.partner = partner
        self.listener = listener
        userLoginLabel.text = partner.login
        //todo добавить реакцию на кнопки
    }
}

protocol PartnerConfirmListener {
    func onPartnerConfirm(partner: Partner)
    func onPartnerReject(partner: Partner)
}
