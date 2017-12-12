//
//  Manager.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 05/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

/**
 The class that executes the algorithm over the data structures
*/
struct AlgorithmManager {
    
    /**
       Get day schedule until the date parameter.
    
    */
    static func getDayScheduleUntil(date dte: Date) -> [Day]{
        
        let lastDate = dte.getDay()
        
        //receives the day after the last cached day, or receives today, if there is no cached days.
        var iteratorDate: Date! = (User.sharedInstance.schedule == nil) ? Date().getDay() : User.sharedInstance.schedule!.last!.date.addingTimeInterval(1.day)
        
        var resultDays: [Day] = []
        
        //Implemented using iterator, not recursivity, because of possibility of memory leak if the date is far away.
        while iteratorDate <= lastDate {
            
            resultDays.append(getDayScheduleFor(date: iteratorDate))
            
            //increase iteratorDate
            iteratorDate = iteratorDate.addingTimeInterval(1.day)
            
        }
        
        
        
    }
    
    /**
     - precondition: date parameter is exactly the next day to be scheduled, according to the cached dates.
     - postcondition: will return a Day with the correct activities scheduled.
    */
    private static func getDayScheduleFor(date: Date) -> Day {
        
        //get weekday
        //get weekday template
        //iterate over contextBlocks
            //activities.append(getActivityForCB method)
        
        //new Day with activities
        //return Day
        
        let weekday = date.getWeekday()

        let weekdayTemplate = User.sharedInstance.getWeekdayTemplate(for: weekday)
    
        var activitiesForDay: [Activity] = []
        
        for contextBlock in weekdayTemplate.contextBlocks {
            
            activitiesForDay.append(getNextActivity(for: contextBlock))
            
        }
        
        
    }
    
    /**
     Returns the next activity to be done for the context block
    */
    private static func getNextActivity(for contextBlock: ContextBlock) -> Activity {
        
        var currentProject: Project? = nil
        
        for project in User.sharedInstance.projects {
            
            if project.context == contextBlock.context {
                
                
                
            }
            
        }
        
        //iterate over user projects
            //if project is of context and has higher priority than currentProject, updates currentProject
        
        
        
    }
    
}
