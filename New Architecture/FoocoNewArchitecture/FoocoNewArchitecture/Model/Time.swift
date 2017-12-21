//
//  Time.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

enum TimeError: Error {
    case OutOfBounds(String)
}

let dailyTotalSeconds = 86_400

struct Time {
    
    var hour: Int {
        return Int(totalSeconds.inHours)
    }
    
    var minute: Int {
        return Int(totalSeconds.inMinutes - hour.minutes)
    }
    
    var second: Int {

        return Int(totalSeconds - hour.hours - minute.minutes)
    }
    
    /**
     total seconds of the time, where 0 is 00:00:00 and 86_399 is 23:59:59
     */
    let totalSeconds: TimeInterval
    
    init(hour h: Int, minute m: Int = 0, second s: Int = 0) throws {
        
        
        if  !TimeRange.hours.contains(h) || !TimeRange.minutes.contains(m) || !TimeRange.seconds.contains(s)  {
            throw TimeError.OutOfBounds("time out of bounds: current value is hour = \(h), minute = \(m) and seconds = \(s).")
        }
        
        self.totalSeconds = h.hour+m.minute+s.seconds
        
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
