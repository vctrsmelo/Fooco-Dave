//
//  Activity.swift
//  Fooco
//
//  Created by Victor S Melo on 19/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class Activity: NSObject {
    
    var project: Project
    var timeBlock: TimeBlock
    
    init(withProject proj: Project, at tb: TimeBlock) {
		project = proj
        timeBlock = tb
		super.init()
    }
    
}
