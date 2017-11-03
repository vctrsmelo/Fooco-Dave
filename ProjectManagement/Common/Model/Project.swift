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
        var timeLeft = totalTimeEstimated
        for activity in scheduledActivities {
            timeLeft -= activity.timeBlock.totalTime
        }
        return timeLeft
        
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
        let ta = User.sharedInstance.weekSchedule.getWorkingSeconds(for: self.context, from: Date(), to: endingDate, consideringEvents: true)
        let sf = 1.0 - User.sharedInstance.safetyMargin

        return ((ta * sf) / (tl*p))

    }

    func userScheduleInvalidated() {
        scheduledActivities = []
    }

    func getNextActivity(for tbl: TimeBlock) -> Activity? {

        //if timeBlock is smaller than the minimal acceptable and the time left of project is bigger than this minimal acceptable value, should not create the activity.
        if context.minProjectWorkingTime != nil && tbl.totalTime < context.minProjectWorkingTime! && self.timeLeftEstimated >= context.minProjectWorkingTime! {
            return nil
        }
        
        //really creates the activity
        let activity = allocateActivity(for: tbl)
        scheduledActivities.append(activity)
        return activity
    }
    
    private func allocateActivity(for tbl: TimeBlock) -> Activity {
        
        let maxTime = context.maxProjectWorkingTime
        let newActivity = (maxTime == nil || tbl.totalTime <= maxTime!) ? Activity(withProject: self, at: tbl) : Activity(withProject: self, at: TimeBlock(startsAt: tbl.startsAt, endsAt: tbl.startsAt.addingTimeInterval(maxTime!)))
        return newActivity
        
    }
    
}

extension Project: Comparable, Equatable {
    
    static func <(lhs: Project, rhs: Project) -> Bool { //:swiftlint:disable:this operator_whitespace
        
        return (lhs.getPriorityValue() < rhs.getPriorityValue())
    
    }
    
    static func ==(lhs: Project, rhs: Project) -> Bool { //:swiftlint:disable:this operator_whitespace
        
        return (lhs.getPriorityValue() == rhs.getPriorityValue())

    }
    
}

extension Project: Hashable {
    
    var hashValue: Int {
        return name.hashValue
    }
    
}
