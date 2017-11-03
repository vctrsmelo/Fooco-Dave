//
//  Event.swift
//  Fooco
//
//  Created by Victor S Melo on 01/11/17.
//

import Foundation

class Event {
    
    var name: String
    var timeBlock: TimeBlock
    
    init(named: String, startsAt: Date, endsAt: Date, at tbl: TimeBlock) {
        name = named
        timeBlock = tbl
    }
    
}

extension Event: Equatable {
    static func ==(lhs: Event, rhs: Event) -> Bool {
        return lhs.timeBlock == rhs.timeBlock && lhs.name == rhs.name
    }
    
}
