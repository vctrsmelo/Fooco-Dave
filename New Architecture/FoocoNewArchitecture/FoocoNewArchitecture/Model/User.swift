//
//  User.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 05/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

typealias WeekTemplate = (WeekdayTemplate,WeekdayTemplate,WeekdayTemplate,WeekdayTemplate,WeekdayTemplate,WeekdayTemplate,WeekdayTemplate)

struct User {
    
    static let sharedInstance = User()
    
    var projects: [Project]
    var contexts: [Context]
    private(set) var weekTemplate: WeekTemplate
    
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
            self.weekTemplate = (WeekdayTemplate(weekday: .sunday),WeekdayTemplate(weekday: .monday),WeekdayTemplate(weekday: .tuesday),WeekdayTemplate(weekday: .wednesday),WeekdayTemplate(weekday: .thursday),WeekdayTemplate(weekday: .friday),WeekdayTemplate(weekday: .saturday))
        }
        
        self.projects = projects
        self.contexts = contexts
        self.schedule = schedule
        
    }
    
    func getWeekdayTemplate(for weekday: Weekday) -> WeekdayTemplate {
        switch weekday {
        case .sunday:
            return weekTemplate.0
        case .monday:
            return weekTemplate.1
        case .tuesday:
            return weekTemplate.2
        case .wednesday:
            return weekTemplate.3
        case .thursday:
            return weekTemplate.4
        case .friday:
            return weekTemplate.5
        case .saturday:
            return weekTemplate.6
        }
    }
    
}
