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

struct Time {

    let hour: Int
    let minute: Int
    let second: Int

    init(hour h: Int, minute m: Int = 0, second s: Int = 0) throws {
        
        if !TimeRange.hours.contains(h) || !TimeRange.minutes.contains(m) || !TimeRange.seconds.contains(s) {
            throw TimeError.OutOfBounds("hour and minute must be between 0 and 60: current value is hour = \(h) and minute = \(m).")
        }
        
        hour = h
        minute = m
        second = s

    }

}

extension Time: Comparable {
    
    static func <(lhs: Time, rhs: Time) -> Bool {
        return (lhs.hour < rhs.hour || (lhs.hour == rhs.hour && lhs.minute < rhs.minute) || (lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.second < rhs.second))

    }
    
    static func ==(lhs: Time, rhs: Time) -> Bool {
        return lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.second == rhs.second
    }
    
    
}
