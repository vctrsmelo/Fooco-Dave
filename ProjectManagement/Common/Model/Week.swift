//
//  Week.swift
//  Fooco
//
//  Created by Victor S Melo on 19/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

struct Week {
    
    var monday: Weekday
    var tuesday: Weekday
    var wednesday: Weekday
    var thursday: Weekday
    var friday: Weekday
    var saturday: Weekday
    var sunday: Weekday
    
    /**
     Return the repective weekday schedule.
     - Parameters:
         - val: the number of the weekday. 1 is monday, 7 is sunday.
     */
    func getDay(_ val: Int) -> Weekday? {
        switch val {
            case 1:
                return monday.copy() as? Weekday
            case 2:
                return tuesday.copy() as? Weekday
            case 3:
                return wednesday.copy() as? Weekday
            case 4:
                return thursday.copy() as? Weekday
            case 5:
                return friday.copy() as? Weekday
            case 6:
                return saturday.copy() as? Weekday
            case 7:
                return sunday.copy() as? Weekday
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
     return the default working hours allocated for the context. Does not consider the user calendar events
    */
    func getDefaultWeeklySecondsFor(context: Context) -> TimeInterval {
        
        var seconds: TimeInterval = 0.0
        
        for i in 1 ... 7 {
            
            seconds += getDefaultDailySecondsFor(context: context, at: i)
            
        }
        
        return seconds
        
    }
    
    /**
     return the default working hours allocated for the context at that weekday. Does not consider the user calendar events
     */
    func getDefaultDailySecondsFor(context: Context, at weekday: Int) -> TimeInterval {
        
        var seconds: TimeInterval = 0.0
        
        guard let day = getDay(weekday) else { return 0.0 }
        
        for block in day.contextBlocks {
            
            if block.context == context {
                
                seconds += DateInterval(start: block.timeBlock.startsAt, end: block.timeBlock.endsAt).duration
                
            }
            
        }
        
        return seconds
        
    }
    
    /**
     return the default working hours allocated for the context at that weekday. Does not consider the user calendar events
     */
    func getDailySecondsFor(context: Context, at date: Date) -> TimeInterval {
        
        let weekdayAsInt = Calendar.current.component(.weekday, from: date)
        guard let weekday = self.getDay(weekdayAsInt) else { return 0.0 }
        let eventsAtDate = User.sharedInstance.getEvents(at: date)

        var secondsLeft = 0.0
        
        for contextBlock in weekday.contextBlocks {
            
            if contextBlock.context != context {
                continue
            }
            
            for event in eventsAtDate {
                
                let resultingTimeBlocks = contextBlock.timeBlock - event
                
                for tb in resultingTimeBlocks {
                    secondsLeft += tb.totalTime
                }
                
            }
            
        }
        
        return secondsLeft
        
    }

    func getWorkingSeconds(for context: Context, from startingDate: Date, to endingDate: Date) -> TimeInterval{
        
        var date = startingDate
        let aDayInSeconds: TimeInterval = 86400
        var seconds: TimeInterval = 0.0
        
        while date <= endingDate {
            
            seconds += self.getDailySecondsFor(context: context, at: date)
            
            date.addTimeInterval(aDayInSeconds)
        }
        
        return seconds
        
    }
    
}
