//
//  TestElementsFactory.swift
//  FoocoNewArchitectureTests
//
//  Created by Victor S Melo on 22/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class TestElementsFactory {
    
    
    /**
     - Precondition: WeekdayContextBlocks.count <= 7
     - Returns: weekly schedule made from WeekdayContextBlocks, starting sunday.
    */
    static func getWeekSchedule(WeekdayContextBlocks dailyContextBlocks: [(Weekday,[ContextBlock])]) -> WeekTemplate {
    
        var sun = WeekdayTemplate(weekday: .sunday)
        var mon = WeekdayTemplate(weekday: .monday)
        var tue = WeekdayTemplate(weekday: .tuesday)
        var wed = WeekdayTemplate(weekday: .wednesday)
        var thu = WeekdayTemplate(weekday: .thursday)
        var fri = WeekdayTemplate(weekday: .friday)
        var sat = WeekdayTemplate(weekday: .saturday)
        
        for weekday in dailyContextBlocks {
            
            switch weekday.0 {
            case .sunday:
                sun = WeekdayTemplate(weekday: weekday.0, contextBlocks: weekday.1)
                break
            case .monday:
                mon = WeekdayTemplate(weekday: weekday.0, contextBlocks: weekday.1)
                break
            case .tuesday:
                tue = WeekdayTemplate(weekday: weekday.0, contextBlocks: weekday.1)
                break
            case .wednesday:
                wed = WeekdayTemplate(weekday: weekday.0, contextBlocks: weekday.1)
                break
            case .thursday:
                thu = WeekdayTemplate(weekday: weekday.0, contextBlocks: weekday.1)
                break
            case .friday:
                fri = WeekdayTemplate(weekday: weekday.0, contextBlocks: weekday.1)
                break
            case .saturday:
                sat = WeekdayTemplate(weekday: weekday.0, contextBlocks: weekday.1)
                break
            }
            
        }
        
        return (sun,mon,tue,wed,thu,fri,sat)
        
    }
    
}
