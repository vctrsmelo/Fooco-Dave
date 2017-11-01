//
//  Project.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class Project {
    
    var name: String
    var startingDate: Date
    var endingDate: Date
    var context: Context
    var priority: Int
    var totalTimeEstimated: TimeInterval
    var timeLeftEstimated: TimeInterval {
        get{
            var timeLeft = totalTimeEstimated
            for activity in scheduledActivities {
                timeLeft -= activity.timeBlock.totalTime
            }
            return timeLeft
        }
        
    }
    private var scheduledActivities: [Activity] = []
    
    
    init(named: String, startsAt: Date, endsAt: Date, withContext ctxt: Context, andPriority prior: Int = 1, totalTimeEstimated totalTime: TimeInterval) {
        name = named
        startingDate = startsAt
        endingDate = endsAt
        context = ctxt
        priority = prior
        totalTimeEstimated = totalTime
    }

    func getPriorityValue() -> Double {

        let tl = timeLeftEstimated
        let p: Double = Double(priority)
        let ta = User.sharedInstance.weekSchedule.getWorkingSeconds(for: self.context, from: Date(), to: endingDate)
        let sf = 1.0 - User.sharedInstance.safetyMargin

        return (ta*sf - tl)*p

    }

    func userScheduleInvalidated() {
        scheduledActivities = []
    }

    func getAnActivityFor(timeBlock: TimeBlock) -> Activity {

        var newActivity = Activity(withProject: self, at: timeBlock)
        scheduledActivities.append(newActivity)
        return newActivity

    }
    
}

extension Project: Comparable, Equatable {
    
    static func <(lhs: Project, rhs: Project) -> Bool {
        
        return (lhs.getPriorityValue() < rhs.getPriorityValue())
    
    }
    
    static func ==(lhs: Project, rhs: Project) -> Bool {
        
        return (lhs.getPriorityValue() == rhs.getPriorityValue())

    }
    
}

extension Project: Hashable {
    
    var hashValue: Int {
        return name.hashValue
    }
    
    
}

