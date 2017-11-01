//
//  User.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class User: NSObject {
    
    static let sharedInstance = User()
    
    var projects: [Project]
    var contexts: [Context]
    var weekSchedule: Week
    var safetyMargin = 0.2 //20%
    
    var currentSchedule: [Date:Weekday] = [:]
    
    private var _isCurrentScheduleUpdated: Bool = false
    var isCurrentScheduleUpdated: Bool {
        get {
            return _isCurrentScheduleUpdated
        }
        set {
            
            if newValue == false {
                for proj in projects{
                    proj.userScheduleInvalidated()
                }
            }
            
            _isCurrentScheduleUpdated = newValue
            
        }
        
    }
    
    private init(projects projs: [Project] = [], contexts ctxs: [Context] = [], week wk: Week = Week()) {
        projects = projs
        contexts = ctxs
        weekSchedule = wk
		
        projects.sort()
        
    }

    /**
     Append the projects into user current projects list
    */
    func add(projects projs: [Project]) {
        projects.append(contentsOf: projs)
        projects.sort()
    }
    
    func add(contexts ctxs: [Context]) {
        contexts.append(contentsOf: ctxs)
    }
    
    func set(weekSchedule wk: Week) {
        weekSchedule = wk
    }
    
    /**
     return the user events of date as TimeBlock
     */
    func getEvents(at date: Date) -> [TimeBlock] {
        
        
        return [] //TODO: implement this method
    }
    
    func updateCurrentScheduleUntil(date: Date) {
        
        isCurrentScheduleUpdated = false
        self.updateCurrentScheduleUntilAux(date: date)
        isCurrentScheduleUpdated = true
        
    }
    
    private func updateCurrentScheduleUntilAux(date: Date) {
        
        if date > Date() {
            
            updateCurrentScheduleUntil(date: Calendar.current.date(byAdding: .day, value: -1, to: date)!)
            
        }
        
        let weekdayAsInt = Calendar.current.component(.weekday, from: date)
        
        guard var weekday = self.weekSchedule.getDay(weekdayAsInt) else { return }
        
        let events = self.getEvents(at: date)
        
        loopContextBlocks: for contextBlock in weekday.contextBlocks {
            
            contextBlock.discountEventsTimeIfApplicable(events: events)
            let availableTimeBlocksInContentBlock = contextBlock.leftTimeBlocks
            
            var currentProject: Project? = nil
            for project in projects {
                if project.context == contextBlock.context {
                    currentProject = project
                    break
                }
            }
            
            if currentProject == nil {
                continue loopContextBlocks
            }
            
            loopTbs: for tb in availableTimeBlocksInContentBlock {
            
                var i = 0
                
                while currentProject == nil && i < projects.count && ((projects[i].context != contextBlock.context) || projects[i].timeLeftEstimated > 0) {
                    i += 1
                }
                
                if i >= projects.count {
                    continue loopContextBlocks
                    
                } else {
                    currentProject = projects[i]
                }
                
                
                
                if contextBlock.context.minimalWorkingTimePerProject != nil && tb.totalTime < contextBlock.context.minimalWorkingTimePerProject! && currentProject!.timeLeftEstimated >= contextBlock.context.minimalWorkingTimePerProject! {
                    continue loopTbs
                }
                
                var timeBlockForActivity: TimeBlock = tb
                
                let maxTime = contextBlock.context.maximumWorkingTimePerProject
                if maxTime != nil && tb.totalTime > maxTime! {
                    
                    timeBlockForActivity = TimeBlock(startsAt: tb.startsAt, endsAt: tb.startsAt.addingTimeInterval(maxTime!))
                    
                }
                
                let activity = currentProject!.getAnActivityFor(timeBlock: timeBlockForActivity)
                contextBlock.activities.append(activity)
                currentProject = nil
                
            }
            
        }
        
        currentSchedule[date] = weekday
        
    }

}
