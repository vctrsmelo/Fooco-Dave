//
//  ActivityScheduler.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 15/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

enum ActivitySchedulerError: Error {
    case ActivityOutOfTimeBlocksBound
}

extension ActivitySchedulerError: CustomStringConvertible {
    var description: String {
        switch self {
        case .ActivityOutOfTimeBlocksBound: return "Tried to add an activity out of available timeblocks limits"
        }
    }
}

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
    func add(activity: Activity) throws {

        let tbl = activity.timeBlock
        
        for tb in timeBlocks {
            
            //if found timeBlock in timeBlocks that contains the timeBlock of activity
            if tb.contains(tbl) {
                
                //remove the timeBlock container
                timeBlocks.remove(at: timeBlocks.index(of: tb)!)
                timeBlocks.append(contentsOf: tb.getComplement(activity.timeBlock))
            
                //add activity into activities
                activities.append(activity)
            
                return
                
            }
        }
        
        throw ActivitySchedulerError.ActivityOutOfTimeBlocksBound
        
    }
    
    
    
}
