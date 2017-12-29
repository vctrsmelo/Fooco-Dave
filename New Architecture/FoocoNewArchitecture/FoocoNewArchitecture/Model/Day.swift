//
//  Day.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 08/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

enum DayError: Error {
    case ActivitiesOverlapping
}

extension DayError: CustomStringConvertible {
    var description: String {
        switch self {
        case .ActivitiesOverlapping: return "The activities in a day should not overlap."
        }
    }
}


struct Day {
    
    private let id: UUID
    
    let date: Date
    var activities: [Activity]
    
    init(date: Date, activities: [Activity] = []) throws  {

        self.date = date.getDay()
        
        self.activities = activities
        self.id = UUID()
        
        if isOverlapping(activities) {
            throw DayError.ActivitiesOverlapping
        }
    
    }
    
    /**
     Should be used internally just to load from database
     */
    private init(date: Date, activities: [Activity] = [], id: UUID) {
        self.date = date
        self.activities = activities
        self.id = id
    }
    
    /**
     return true if there is some activity in the parameter list that is overlapping with other activity from the list.
    */
    private func isOverlapping(_ activities: [Activity]) -> Bool {
        
        if activities.count > 1 {

            //loop through all activities, comparing their timeBlock through overlaps method.
            for i in 0 ..< activities.count-1 {
                for j in i+1 ..< activities.count {
                    if activities[i].overlaps(activities[j]){
                        return true
                    }
                }
            }
        }
        return false
    }
    
}

extension Day: Comparable {
    
    static func <(lhs: Day, rhs: Day) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func ==(lhs: Day, rhs: Day) -> Bool {
        return lhs.date == rhs.date
    }
    
    
}
