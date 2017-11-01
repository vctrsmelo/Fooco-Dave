//
//  Weekday.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class Weekday {
    
    var contextBlocks: [ContextBlock]
    
    init(contextBlocks blocks: [ContextBlock] = []) {
        
        contextBlocks = blocks
        
    }
    
}

extension Weekday: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        var contextBlocksCopy: [ContextBlock] = []
        for cb in contextBlocks {
        
            cb.copy()

        }
        
        return Weekday(contextBlocks: contextBlocksCopy)
    
    }
    
    
    
}
