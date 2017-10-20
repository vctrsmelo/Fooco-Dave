//
//  Project.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class Project: NSObject {
    
    var name: String
    var startingDate: Date
    var endingDate: Date
    var context: Context
    var priority: Int
    
    init(named: String, startsAt: Date, endsAt: Date, withContext ctxt: Context, andPriority prior: Int = 0) {
        name = named
        startingDate = startsAt
        endingDate = endsAt
        context = ctxt
        priority = prior
        
    }
    
    
    
}
