//
//  Team.swift
//  HotchSportsProto
//
//  Created by Roger Wistar on 10/17/18.
//  Copyright © 2018 Roger Wistar. All rights reserved.
//

import Foundation

var allTeams = [Team]()

struct Team: CustomStringConvertible {
    var myTeamName: String
    
    var description: String {
        return myTeamName
    }
}
