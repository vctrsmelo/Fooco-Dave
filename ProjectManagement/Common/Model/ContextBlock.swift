//
//  ContextBlock.swift
//  Fooco
//
//  Created by Victor S Melo on 19/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class ContextBlock{
    
    var timeBlock: TimeBlock
    var context: Context
    
    var activities: [Activity]
    
    init(timeBlock tb: TimeBlock, context ctx: Context, activities actvs: [Activity] = []) {
        
        timeBlock = tb
        context = ctx
        activities = actvs
        
    }
    
}
