//
//  Event.swift
//  Fooco
//
//  Created by Victor S Melo on 01/11/17.
//

import Foundation

class Event: TimeBlock {
    
    var name: String
    
    init(named: String, startsAt: Date, endsAt: Date) {
        name = named
        super.init(startsAt: startsAt, endsAt: endsAt)
    }
    
}
