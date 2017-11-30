//
//  WeekdayTemplate.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

/**
 weekdays, where sunday is 0 and saturday is 6
 */
enum Weekday: Int {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
}

/**
 The template for user's weekday. It includes the respective weekday and the contextblocks of these weekdays.
 */
struct WeekdayTemplate {
    
    var weekday: Weekday
    private var contextBlocks: [ContextBlock] = []

    init(weekday: Weekday, contextBlocks: [(TimeBlock, Context)] = []) {

        self.weekday = weekday
        
        for tuple in contextBlocks {
            self.contextBlocks.append(ContextBlock(tuple))
        }
        
    }
    
    // Private struct
    private struct ContextBlock {
        let context: Context
        let timeBlock: TimeBlock
        
        init(context: Context, timeBlock: TimeBlock) {
            self.context = context
            self.timeBlock = timeBlock
        }
        
        init(_ tuple: (TimeBlock, Context)) {
            self.init(context: tuple.1, timeBlock: tuple.0)
        }
    }
    
}

