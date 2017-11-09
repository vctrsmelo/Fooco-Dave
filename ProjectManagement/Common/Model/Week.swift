//
//  Week.swift
//  Fooco
//
//  Created by Victor S Melo on 19/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

struct Week {

    var sunday: Weekday
    var monday: Weekday
    var tuesday: Weekday
    var wednesday: Weekday
    var thursday: Weekday
    var friday: Weekday
    var saturday: Weekday
    
    init(sunday sun: Weekday, monday mon: Weekday, tuesday tue: Weekday, wednesday wed: Weekday, thursday thu: Weekday, friday fri: Weekday, saturday sat: Weekday) {

        sunday = sun
        monday = mon
        tuesday = tue
        wednesday = wed
        thursday = thu
        friday = fri
        saturday = sat

    }
    
    /**
     Return the repective weekday schedule.
     - Parameters:
         - val: the number of the weekday. 1 is monday, 7 is sunday.
     */
    func getDay(_ val: Int) -> Weekday? {
        switch val {
            case 1:
                return sunday
            case 2:
                return monday
            case 3:
                return tuesday
            case 4:
                return wednesday
            case 5:
                return thursday
            case 6:
                return friday
            case 7:
                return saturday
            default:
                return nil
        }
        
    }
    
    init() {
        monday = Weekday()
        tuesday = Weekday()
        wednesday = Weekday()
        thursday = Weekday()
        friday = Weekday()
        saturday = Weekday()
        sunday = Weekday()
    }
    
    func getDay(for date: Date) -> Weekday? {
        
        let weekdayAsInt = Calendar.current.component(.weekday, from: date)
        
        return self.getDay(weekdayAsInt)
        
    }
        
    /**
     return the default working hours allocated for the context in a week.
    */
    func getWeeklyWorkingSeconds(for context: Context) -> TimeInterval {
        
        var seconds: TimeInterval = 0.0
        
        for i in 1 ... 7 {
            
            seconds += getDefaultDailySeconds(for: context, at: self.getDay(i)!)
            
        }
        
        return seconds
        
    }
    
    /**
     return the default working hours allocated for the context at that weekday.
     */
    func getDefaultDailySeconds(for context: Context, at weekday: Weekday) -> TimeInterval {
    
        var secondsLeft: TimeInterval = 0.0
        
        for block in weekday.contextBlocks {
            
            if block.context != context {
                continue
            }

            secondsLeft += block.leftTime
            
        }
        
        return secondsLeft
        
    }
    
    /**
     return the default working hours allocated for the context at that weekday. May consider the user calendar events
     */
    func getDailySeconds(for context: Context, at date: Date, consideringEvents: Bool) -> TimeInterval {
        
        let weekdayAsInt = Calendar.current.component(.weekday, from: date)
        guard let weekday = self.getDay(weekdayAsInt) else { return 0.0 }
        
        var secondsLeft: TimeInterval = 0.0
        let eventsAtDate = User.sharedInstance.getEvents(at: date)
        
        for block in weekday.contextBlocks {
            
            if block.context != context {
                continue
            }
            
            if consideringEvents {
                block.discountEventsTimeIfApplicable(events: eventsAtDate)
            }
            
            secondsLeft += block.leftTime
            
        }
        
        return secondsLeft
    
    }

    func getWorkingSeconds(for context: Context, from startingDate: Date, to endingDate: Date, consideringEvents: Bool) -> TimeInterval {
        
        var date = startingDate
        let aDayInSeconds: TimeInterval = 86_400
        var seconds: TimeInterval = 0.0
        
        while date <= endingDate {
            
            seconds += self.getDailySeconds(for: context, at: date, consideringEvents: consideringEvents)
            date.addTimeInterval(aDayInSeconds)
            
        }
        
        return seconds
        
    }
    
}
