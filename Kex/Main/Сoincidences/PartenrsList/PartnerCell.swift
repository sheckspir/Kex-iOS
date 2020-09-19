//
//  PartnerCell.swift
//  Kex
//
//  Created by Alex on 17.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import UIKit

class PartnerCell: UITableViewCell {

    @IBOutlet weak var userLoginLabel: UILabel!
    
    private var partner: Partner? = nil
    private var listener : PartnerClickListener? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if (selectionStyle != .none && selected && partner != nil && listener != nil) {
            listener?.onPartnerClicked(partner: partner!)
        }
    }
    
    func showPartner(partner: Partner, listener : PartnerClickListener) {
        self.partner = partner
        self.listener = listener
        userLoginLabel.text = partner.login
    }

}

protocol PartnerClickListener {
    func onPartnerClicked(partner: Partner)
}
