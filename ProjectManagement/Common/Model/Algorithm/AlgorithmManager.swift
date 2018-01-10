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
       Get day schedule until the date parameter. The parameter since represents the starting date, the lowest limit of schedule. It's useful for cases when an activity is skipped, so a new activity should not be returned for the skipped activity time.
    
    */
    static func getDayScheduleFor(date dte: Date, since startingDate: Date? = nil) throws -> [Day] {
        
        let lastDate = dte.getDay()
        
        //receives the day after the last cached day, or receives today, if there is no cached days.
        var iteratorDate: Date! = (User.sharedInstance.schedule == nil || User.sharedInstance.schedule!.isEmpty) ? Date().getDay() : User.sharedInstance.schedule!.last!.date.addingTimeInterval(1.day)

        //if a starting date was defined, iteratorDate starts at startingDate day.
        if startingDate != nil && iteratorDate.getDay() < startingDate!.getDay() {
            
            iteratorDate = startingDate!.getDay()
            
        }
        
        var resultDays: [Day] = []
        
        //Implemented using iterator, not recursive because of possibility of memory leak if the date is far in the future.
        while iteratorDate <= lastDate {
            
            //if a startingDate was defined, and iteratorDate is before it, then staringDate should be used to get the day schedule.
            if startingDate != nil && iteratorDate < startingDate! {
                
                try resultDays.append(getDayScheduleForAux(date: startingDate!))

            } else {
            
                try resultDays.append(getDayScheduleForAux(date: iteratorDate))
            
            }
            
            //increase iteratorDate
            iteratorDate = iteratorDate.addingTimeInterval(1.day)
            
        }
        
        return resultDays
        
    }
    
    /**
     - precondition: date parameter is exactly the next day to be scheduled, according to the cached dates.
     - postcondition: will return a Day with the correct activities scheduled.
    */
    private static func getDayScheduleForAux(date: Date) throws -> Day {

        //get weekdayTemplate
        let weekdayTemplate = (date.getTime() == date.getDay().getTime()) ? User.sharedInstance.getWeekdayTemplate(for: date.getWeekday()) : User.sharedInstance.getWeekdayTemplate(for: date.getWeekday(), startingAt: date.getTime())
    
        var activitiesForDay: [Activity] = []
        
        //iterate over Context Blocks of weekdayTemplate to append activities into activitiesForDay
        for contextBlock in weekdayTemplate.contextBlocks {
            
            //Problema: context block pode ter mais de uma activity em si. Precisa considerar isso. (RESOLVIDO)
            //Problem: corner case, when context block continues until next day

            //cria scheduler
            let scheduler = ActivityScheduler(timeBlock: contextBlock.timeBlock, context: contextBlock.context)

            //enquanto scheduler tem time blocks disponíveis
            while !scheduler.getAvailableTimeBlocks().isEmpty {
                
                //tenta adicionar proxima atividade no timeBlock disponível
                guard let nextActivity = getNextActivity(for: scheduler) else {
                    
                    //can not allocate another activity into scheduler. Should get out from this while loop.
                    break
                    
                }
                
                try! scheduler.add(activity: nextActivity)
                
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
        
        //sort projects by their priorities
        highestProjects.sort { $0.priority > $1.priority }
        
        var i = 0
        while highestProjects.count > i {

            let highestProject = highestProjects[i]
            
            //if timeBlock length is smaller than minimalTimeLength for activity, skip it
            for timeBlock in (scheduler.getAvailableTimeBlocks().filter { $0.length >= Activity.minimalTimeLength }) {
                
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
        
        var projects: [Project] = []
        
        //iterate over user projects
        for project in (User.sharedInstance.projects.filter { $0.context == context }) {
            
            projects.append(project)

        }
        
        return projects
        
    }
    
}
