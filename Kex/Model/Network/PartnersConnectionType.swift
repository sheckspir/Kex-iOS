//
//  PartnersConnectionType.swift
//  Kex
//
//  Created by Alex on 18.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

enum PartnerConnectionType: String, Codable, CaseIterable {
    case CONNECTED
    case NEW_REQUEST_FROM
    case WAIT_RESPONCE
    case REJECTED
}
