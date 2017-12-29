//
//  User.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 05/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

struct User {
    
    static var sharedInstance = User()
    
    var projects: [Project]
    var contexts: [Context]
    var weekTemplate: WeekTemplate
    
    /**
        is optional because if schedule changes, must invalidate current schedule cached.
        invariant: must be ordered
    */
    private var _scheduleCache: [Day]?
    
    //this variable exists just as a better interface for scheduleCache.
    var schedule: [Day]? {
        get{
            return _scheduleCache
        }
        set{
            _scheduleCache = newValue?.sorted()
        }
    }
    
    private init(projects: [Project] = [], contexts: [Context] = [], weekTemplate: WeekTemplate? = nil, schedule: [Day]? = nil) {
        
        if let weekTemp = weekTemplate {
            self.weekTemplate = weekTemp
        } else {
            
            self.weekTemplate = WeekTemplate(sun: WeekdayTemplate(weekday: .sunday),mon: WeekdayTemplate(weekday: .monday),tue: WeekdayTemplate(weekday: .tuesday),wed: WeekdayTemplate(weekday: .wednesday),thu: WeekdayTemplate(weekday: .thursday),fri: WeekdayTemplate(weekday: .friday),sat: WeekdayTemplate(weekday: .saturday))
        }
        
        self.projects = projects
        self.contexts = contexts
        self.schedule = schedule
        
    }
    
    /**
     Returns the time available for a context until the date parameter, including it. Discount the activities already allocated into schedule.
    */
    func getAvailableTime(for context: Context, until date: Date) -> TimeInterval{

        var returnValue: TimeInterval = 0.0
        //recursive get each day until today (obs: into today, verifies the current time)
        if !date.isToday() {
            
            returnValue += getAvailableTime(for: context, until: date.addingTimeInterval(-1.day))
            
        }
        
        //get date available time for context
        let weekdayTemplate = getWeekdayTemplate(for: date.getWeekday())
        
        //keep contextblocks of context parameter at weekday.
        var weekdayContextBlocks: [ContextBlock] = []
        
        //add contextBlocks lengths if it's for context parameter
        for contextBlock in weekdayTemplate.contextBlocks {
            
            if contextBlock.context == context {
                
                returnValue += contextBlock.timeBlock.length

                weekdayContextBlocks.append(contextBlock)

            }
            
        }
        
        //decrease activities length if date is already in schedule
        guard let currentSchedule = schedule else {
            return returnValue
        }
        
        for day in currentSchedule {
            
            //if day is not the weekday being verified, skip it
            if day.date.getWeekday() != weekdayTemplate.weekday {
                continue
            }
            
            for activity in day.activities {

                //if it's an activity for a project
                if let project = activity.project {
                    
                    //verifies if context is the same. If it's, discount the already allocated time from returnValue and continue loop over day.activities
                    if project.context == context {
                        returnValue -= activity.length
                        continue
                    }

                }

                //activity is an event from user calendar. Should discount it's time if it occurs during a context of weekdayContextBlocks
                let calendarEvent = activity
                
                //verifies if calendarEvent occurs during a contextBlock timeBlock for the context parameter.
                for contextBlock in weekdayContextBlocks {
                    
                    //clampedTimeBlock is the timeBlock created from intersection between contextBlock and calendarEvent.timeBlock
                    let clampedTimeBlock = contextBlock.timeBlock.clamp(calendarEvent.timeBlock)
                    
                    //discounts clampedTimeBlock length. If contextBlock does not clamp with calendarEvent, this discount will be of zero, not affecting the algorithm logic.
                    returnValue -= clampedTimeBlock.length
                    
                }
                
                
            }
            
        }
        
        return returnValue
        
    }
    
    /**
     Returns the weekly available time for a context.
    */
    func getWeeklyAvailableTime(for context: Context) -> TimeInterval {
        

        var weekContextBlocks = weekTemplate.value.0.contextBlocks
        weekContextBlocks.append(contentsOf: weekTemplate.value.1.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.2.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.3.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.4.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.5.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.6.contextBlocks)

        var availableTime: TimeInterval = 0.0
        for contextBlock in weekContextBlocks {
            
            if contextBlock.context != context {
                continue
            }

            availableTime += contextBlock.timeBlock.length

        }
        
        return availableTime
        
    }
    
    func getWeekdayTemplate(for weekday: Weekday) -> WeekdayTemplate {
        switch weekday {
        case .sunday:
            return weekTemplate.value.0
        case .monday:
            return weekTemplate.value.1
        case .tuesday:
            return weekTemplate.value.2
        case .wednesday:
            return weekTemplate.value.3
        case .thursday:
            return weekTemplate.value.4
        case .friday:
            return weekTemplate.value.5
        case .saturday:
            return weekTemplate.value.6
        }
    }
    
}
