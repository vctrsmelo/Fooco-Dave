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
    static func getDayScheduleFor(date dte: Date) -> [Day]{
        
        let lastDate = dte.getDay()
        
        //receives the day after the last cached day, or receives today, if there is no cached days.
        var iteratorDate: Date! = (User.sharedInstance.schedule == nil) ? Date().getDay() : User.sharedInstance.schedule!.last!.date.addingTimeInterval(1.day)
        
        var resultDays: [Day] = []
        
        //Implemented using iterator, not recursive because of possibility of memory leak if the date is far in the future.
        while iteratorDate <= lastDate {
            
            resultDays.append(getDayScheduleForAux(date: iteratorDate))
            
            //increase iteratorDate
            iteratorDate = iteratorDate.addingTimeInterval(1.day)
            
        }
        
        
        
    }
    
    /**
     - precondition: date parameter is exactly the next day to be scheduled, according to the cached dates.
     - postcondition: will return a Day with the correct activities scheduled.
    */
    private static func getDayScheduleForAux(date: Date) throws -> Day {
        
        //get weekdayTemplate
        let weekdayTemplate = User.sharedInstance.getWeekdayTemplate(for: date.getWeekday())
    
        var activitiesForDay: [Activity] = []
        
        //iterate over Context Blocks of weekdayTemplate to append activities into activitiesForDay
        for contextBlock in weekdayTemplate.contextBlocks {
            
            //Problema: context block pode ter mais de uma activity em si. Precisa considerar isso.

            //cria scheduler
            var scheduler = ActivityScheduler(timeBlock: contextBlock.timeBlock, context: contextBlock.context)

            //enquanto scheduler tem time blocks disponíveis
            while !scheduler.getAvailableTimeBlocks().isEmpty {
                
                //tenta adicionar proxima atividade no timeBlock disponível
                guard let nextActivity = getNextActivity(for: scheduler) else {
                    
                    //can not allocate another activity into scheduler. Should get out from this while loop.
                    break
                    
                }
                
                scheduler.add(activity: nextActivity)
                
            }
            
            //add created activities into activitiesForDay
            activitiesForDay.append(contentsOf: scheduler.getActivities())
            
        }
        
        //return Day created with activitiesForDay, if possible (if the activities are not overlapping, what shouldn't be occuring)
        return try Day(date: date, activities: activitiesForDay)
        
    }
    
    /**
     Returns the next activity to be done for the context block
    */
    private static func getNextActivity(for scheduler: ActivityScheduler) -> Activity? {
        
        //tuple of projects and its priority. Uses tuple to not need to recalculate the priority value while executing the algorithm below.
        var highestProjects: [Project] = getProjectsFor(context: scheduler.context)
        
        highestProjects.sort()
        
        var i = 0
        while highestProjects.count > i {

            let highestProject = highestProjects[i]
            
            for timeBlock in scheduler.getAvailableTimeBlocks() {
                
                //if highestProject found an activity for timeBlock
                if let nextActivity = highestProject.nextActivity(for: timeBlock) {

                    //return the nextActivity created
                    return nextActivity

                }
                
            }

            //the highestProject couldn't create an activity. Now will iterate again to try to create an activity for the following project with highest priority value
            i += 1
        }
        
        return nil
        
    }
    
    /**
     Get the list of user's current projects for the context parameter.
    */
    static func getProjectsFor(context: Context) -> [Project] {
        
        var resultArray: [Project] = []
        
        //iterate over user projects
        for project in User.sharedInstance.projects {
            
            if project.context == context {
                
                resultArray.append(project)
                
            }
        }
        
    }
    
}
