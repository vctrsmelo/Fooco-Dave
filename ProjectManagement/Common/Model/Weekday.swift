//
//  Weekday.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

struct Weekday {
    
    var contextBlocks: [ContextBlock] = []
    
    init(contextBlocks blocks: [ContextBlock] = []) {
        
        contextBlocks = getOnlyWeekdayBlocks(from: blocks)
        
    }
    
    func getOnlyWeekdayBlocks(from cbls: [ContextBlock]) -> [ContextBlock] {

        if cbls.isEmpty {
            return []
        }
        
        let today = Calendar.current.component(.day, from: cbls.first!.timeBlock.startsAt)
        var todayContextBlocks: [ContextBlock] = []
        
        for contextBlock in cbls {

            let startsDay = Calendar.current.component(.day, from: contextBlock.timeBlock.startsAt)
            let endsDay = Calendar.current.component(.day, from: contextBlock.timeBlock.endsAt)
            
            if startsDay != today || endsDay != today {
                print("[Error] at Weekday.getOnlyWeekdayBlocks: the following contextblock is not contained in the weekday: \(contextBlock). It starts at \(contextBlock.timeBlock.startsAt) and ends at \(contextBlock.timeBlock.endsAt). It has not been added to the weekday schedule.")
                continue
            }
            
            todayContextBlocks.append(contextBlock)

        }
        
        return todayContextBlocks
        
    }
    
}
