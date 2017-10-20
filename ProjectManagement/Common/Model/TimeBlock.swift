//
//  Timeblock.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class TimeBlock: NSObject {

    var startsAt: Date
    var endsAt: Date
    
    init(startsAt starting: Date, endsAt ending: Date) {
        
        if Calendar.current.compare(starting, to: ending, toGranularity: .hour) != ComparisonResult.orderedDescending {
            
            fatalError("[Timeblock init] tried to create a timeblock with starting date after ending date")
            
        }
        
        startsAt = starting
        endsAt = ending
        
    }
    
}
