//
//  GroupData.swift
//  Kex
//
//  Created by Alex on 15.08.2020.
//  Copyright © 2020 Karamyshev. All rights reserved.
//

import Foundation

class GroupDeleteInfo: Codable{
    var groupId : Int
    
    init(groupId : Int) {
        self.groupId = groupId
    }
}
