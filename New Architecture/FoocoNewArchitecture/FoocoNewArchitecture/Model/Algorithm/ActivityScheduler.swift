//
//  ActivityScheduler.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 15/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class ActivityScheduler {
    
    let context: Context
    private var timeBlocks: [TimeBlock] = []
    private var activities: [Activity] = []
    
    init(timeBlock: TimeBlock, context: Context) {
        self.timeBlocks.append(timeBlock)
        self.context = context
    }
    
    func getAvailableTimeBlocks() -> [TimeBlock] {
        return timeBlocks
    }
    
    /**
     Return the activities allocated for this ActivityScheduler.
    */
    func getActivities() -> [Activity] {
        return activities
    }
    
    /**
     Add an activity into ActivityScheduler
     - precondition: the TimeBlock of activity parameter must be into the list returned by getAvailableTimeBlocks()
    */
    func add(activity: Activity) {

        let tbl = activity.timeBlock
        
        //remove the timeblock tbl from array
        if let index = timeBlocks.index(of: tbl) {
            timeBlocks.remove(at: index)
        }
        
        //get timeblock set from tbl difference to activity
        //re-add left time blocks into timeBlocks array
        self.timeBlocks.append(contentsOf: tbl.getComplement(activity.timeBlock))
        
        //add activity into activities
        activities.append(activity)
        
    }
    
    
    
}
