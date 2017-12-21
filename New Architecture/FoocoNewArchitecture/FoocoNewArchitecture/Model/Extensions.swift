//
//  Extensions.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 30/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

extension Int {
    
    var timeInterval: TimeInterval {
        return TimeInterval(self)
    }
    
    var seconds: TimeInterval {
        return self.timeInterval
    }
    var second: TimeInterval {
        return self.seconds
    }
    
    var minutes: TimeInterval {
        return self.timeInterval * 60.seconds
    }
    var minute: TimeInterval {
        return self.minutes
    }
    
    var hours: TimeInterval {
        return self.timeInterval * 60.minutes
    }
    var hour: TimeInterval {
        return self.hours
    }
    
    var days: TimeInterval {
        return self.timeInterval * 24.hours
    }
    var day: TimeInterval {
        return self.days
    }
    
}

extension TimeInterval {

    /**
     Return the value in hours unit
    */
    var inHours: Double {
        return self / 1.hour
    }

    /**
     Return the value in days unit
     */
    var inDays: Double {
        return self / 1.day
    }
    
    /**
     Return the value in minutes unit
     */
    var inMinutes: Double {
        return self / 1.minute
    }
    
}

extension Date {
    
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter.string(from: self)
    }
    
    /**
     Return the same date with hours, minutes and seconds setted to zero.
     */
    func getDay() -> Date {
        
        let today = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!)")!
        
    }
    
    /**
     Returns the Weekday.
     - precondition: Calendar must be gregorian, where weekday starts as 1 (sunday) and ends as 7 (saturday).
    */
    func getWeekday() -> Weekday {
        return Weekday(rawValue: Calendar.current.component(.weekday, from: self))!
    }
    
}

extension Array where Element:Project {
    
    /**
     Returns an array of tuples of a project and it's priority value.
     It's useful to keep the priority value in "cache", as it's calculation is not trivial.
    */
    func withPriorityValue(sorted: Bool = false) -> [(Project,Priority)] {
        var returnArray: [(Project,Priority)] = []

        for proj in self {
            returnArray.append((proj,proj.priority))
        }
        
        if sorted {
            //sort by priority values.
            returnArray.sort { (arg0, arg1) -> Bool in
                let priority1 = arg0.1
                let priority2 = arg1.1
                return (priority1 > priority2)
            }
        }
        
        return returnArray
    }
    
    
}

extension Array where Element: Equatable {
    
    /**
     Remove duplicated values
    */
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }

}
