//
//  Time.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

enum TimeError: Error {
    case OutOfBounds
}

extension TimeError: CustomStringConvertible {
    var description: String {
        switch self {
        case .OutOfBounds: return "Time is out of bounds. Probably hour, minute or second is an integer out of it's limit."
        }
    }
}

let dailyTotalSeconds = 86_400

struct Time {
    
    var day: Int {
        return Int(totalSeconds.inDays)
    }
    
    var hour: Int {
        return Int((totalSeconds - day.day).inHours)
    }
    
    var minute: Int {
        return Int((totalSeconds - day.day - hour.hour).inMinutes)
    }
    
    var second: Int {

        return Int(totalSeconds - day.day - hour.hours - minute.minutes)

    }
    
    /**
     total seconds of the time, where 0 is 00:00:00 and 86_399 is 23:59:59
     */
    let totalSeconds: TimeInterval
    
    init(day d: Int = 0,hour h: Int = 0, minute m: Int = 0, second s: Int = 0) throws {
        
        
        if  !TimeRange.hours.contains(h) || !TimeRange.minutes.contains(m) || !TimeRange.seconds.contains(s)  {
            throw TimeError.OutOfBounds
        }
        
        self.totalSeconds = d.day+h.hour+m.minute+s.seconds

    }
    
    init(timeInterval: TimeInterval) {
        
        self.totalSeconds = timeInterval
    }
    
    /**
     - returns: returns Time with the parameter as seconds.
    */
    func addingTimeInterval(_ timeInterval: TimeInterval) -> Time {
        
        return Time(timeInterval: timeInterval+self.totalSeconds)
        
    }
    
}

extension Time: Comparable {
    
    static func <(lhs: Time, rhs: Time) -> Bool {
        
        return lhs.totalSeconds < rhs.totalSeconds
    }
    
    static func ==(lhs: Time, rhs: Time) -> Bool {
        return lhs.totalSeconds == rhs.totalSeconds
    }
    
    
}

extension Time {
    
    static func -(lhs: Time, rhs: Time) -> TimeInterval {
        return lhs.totalSeconds - rhs.totalSeconds
    }
    
}

extension Time: CustomStringConvertible {
    var description: String {
        return "\(hour):\(minute):\(second)"
    }
    
    
}

/**
 Contains time range variables for hours, minutes and seconds.
 */
struct TimeRange {
    
    /**
     The range of seconds, from 0 to 59.
     */
    static let seconds = (0 ... 59)
    
    /**
     The range of minutes, from 0 to 59.
     */
    static let minutes = (0 ... 59)
    
    /**
     The range of hours, from 0 to 23.
     */
    static let hours  = (0 ... 23)
    
}

