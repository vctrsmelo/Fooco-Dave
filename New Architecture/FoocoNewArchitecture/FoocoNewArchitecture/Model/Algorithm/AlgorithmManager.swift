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
            
            //Problema: context block pode ter mais de uma activity em si. Precisa considerar isso.
            
            //cria arvore com apenas a raiz
            var timeBlockTree = TimeBlockTree(root: contextBlock.timeBlock)

            while timeBlockTree
            
            //enquanto arvore tem time block para activities (nao terá mais quando, ao tentar adicionar activity, tiver percorrido toda a arvore e nao conseguiu)
                //tenta adicionar proxima atividade na árvore
            
            
            if let nextActivity = getNextActivity(for: contextBlock) {
                activitiesForDay.append(nextActivity)
            }
            
        }
        
        
    }
    
    /**
     Returns the next activity to be done for the context block
    */
    private static func getNextActivity(for contextBlock: ContextBlock) -> Activity? {
        
        //tuple of projects and its priority. Uses tuple to not need to recalculate the priority value while executing the algorithm below.
        var highestProjects: [Project] = getProjectsFor(context: contextBlock.context)
        
        highestProjects.sort()
        
        var nextActivity: Activity?
        var i = 0
        
        while nextActivity == nil && highestProjects.count > i {

            let highestProject = highestProjects[i]
            
            guard let actv = highestProject.nextActivity(for: contextBlock) else {
                
                //if the highest project can't create a new activity, try to create an activity for the next project in the list.
                i += 1
                continue
            
            }
            
            nextActivity = actv
            
        }
        
        return nextActivity
        
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
