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
