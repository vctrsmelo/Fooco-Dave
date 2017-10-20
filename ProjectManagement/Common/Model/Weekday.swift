//
//  Weekday.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class Weekday: NSObject {
    
    var contextBlocks: [ContextBlock]
    
    init(contextBlocks blocks: [ContextBlock] = []) {
        
        contextBlocks = blocks
        
    }
    
}
