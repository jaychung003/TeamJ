//
//  Group.swift
//  TinderSwipe
//
//  Created by cssummer17 on 6/29/17.
//  Copyright © 2017 cssummer17. All rights reserved.
//

import UIKit

class Group: NSObject {
    var groupName: String!
    var listOfMembers: [String] = []
    var deck = DataManager.sharedData.deck

}
