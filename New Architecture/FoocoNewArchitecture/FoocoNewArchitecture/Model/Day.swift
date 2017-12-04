//
//  Day.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 04/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

struct Day {
    private(set) var activities: [Activity]
    
    init(activities: [Activity]) {
        self.activities = activities
    }
}
