//
//  PartnerInfo.swift
//  Kex
//
//  Created by Alex on 19.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class PartnerInfo : Codable {
    let partnerId : Int

    init(partnerId : Int) {
        self.partnerId = partnerId
    }
}
