//
//  ActivityScheduler.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 15/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class ActivityScheduler {
    
    private var timeBlocks: [TimeBlock] = []
    private var activities: [Activity] = []
    
    init(timeBlock: TimeBlock) {
        self.timeBlocks.append(timeBlock)
    }
    
    func getAvailableTimeBlocks() -> [TimeBlock] {
        return timeBlocks
    }
    
    /**
     Add an activity into ActivityScheduler
     - precondition: the TimeBlock parameter must be into the list returned by getAvailableTimeBlocks()
    */
    func add(activity: Activity, in tbl: TimeBlock) {
        
        for i in 0 ..< timeBlocks.count {
            
            if timeBlocks[i] == tbl {
                
                timeBlocks.remove(at: i)
                
            }
            
        }
        
        //re-add left time blocks into timeBlocks array
        self.timeBlocks.append(contentsOf: tbl.getComplement(activity.timeBlock))
        
        //add activity into activities
        activities.append(activity)
        
    }
    
    
    
}
