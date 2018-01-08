//
//  ContextBlock.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 22/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

struct ContextBlock {
    
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


extension ContextBlock: TimeIntervalType {
    
    /**
     ContextBlock'ss length in seconds.
     */
    var length: TimeInterval {
        return timeBlock.end - timeBlock.start
    }
    
}

extension ContextBlock: Equatable {
    
    static func == (lhs: ContextBlock, rhs: ContextBlock) -> Bool {
        if lhs.context == rhs.context && lhs.timeBlock == rhs.timeBlock {
            return true
        }
        
        return false
        
    }
    
    
}
