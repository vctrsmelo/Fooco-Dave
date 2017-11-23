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
    var importance: Int
    
    var secondsBetweenActivities: TimeInterval = 3_600 //default 1 hour. Maybe in the future we can make available for the user to change it.
    
    var totalTimeEstimated: TimeInterval
    var timeLeftEstimated: TimeInterval {
        var timeLeft = totalTimeEstimated
        for activity in scheduledActivities {
            timeLeft -= activity.timeBlock.totalTime
        }
        
        return timeLeft
        
    }
    
    private var completedActivities: [Activity] = []
    
    var scheduledActivities: [Activity] = []
    
    init(named: String, startsAt: Date, endsAt: Date, withContext ctxt: Context, importance imp: Int = 1, totalTimeEstimated totalTime: TimeInterval) {
        name = named
        startingDate = startsAt
        endingDate = endsAt
        context = ctxt
        importance = imp
        totalTimeEstimated = totalTime
    }
    
    /**
     Return how much of the project was already done, according to the estimated time and already worked time
    */
    func getDonePercentage() -> Double {
        
        var totalTimeDone: TimeInterval = 0
        for activity in completedActivities {
            totalTimeDone += activity.timeBlock.totalTime
        }
        
        return 100.0*(totalTimeDone/totalTimeEstimated)
        
    }

    func getPriorityValue() -> Double {

        let tl = timeLeftEstimated
        let p: Double = Double(importance)
        let ta = User.sharedInstance.weekSchedule.getWorkingSeconds(for: self.context, from: Date(), to: endingDate, consideringEvents: true)
        //let sf = 1.0 - User.sharedInstance.safetyMargin
        //return ((ta * sf) / (tl*p))
        return (ta / (tl*p))

    }

    func userScheduleInvalidated() {
        scheduledActivities = []
    }

    func getNextActivity(for tbl: TimeBlock) -> Activity? {
    
        
        //if can not allocate more activity or timeBlock is smaller than the minimal acceptable and the time left of project is bigger than this minimal acceptable value, should not create the activity.
        if !canAllocateActivity(for: tbl) || (context.minProjectWorkingTime != nil && tbl.totalTime < context.minProjectWorkingTime! && self.timeLeftEstimated >= context.minProjectWorkingTime!) {
            return nil
        }
        
        //really creates the activity
        let activity = allocateActivity(for: tbl)
        scheduledActivities.append(activity)
        return activity
    }
    
    /**
     Creates a new activity for the timeblock tb1 if it is possible to.
    */
    private func allocateActivity(for tbl: TimeBlock) -> Activity {
    
        let maxTime = context.maxProjectWorkingTime
        
        var subTimeBlock = getSubTimeBlockForNewActivity(from: tbl)

        var activityTime = (subTimeBlock.totalTime <= self.timeLeftEstimated) ? subTimeBlock.totalTime : self.timeLeftEstimated
        if maxTime != nil && activityTime > maxTime! {
            activityTime = maxTime!
        }

        return Activity(withProject: self, at: TimeBlock.init(startsAt: subTimeBlock.startsAt, endsAt: subTimeBlock.startsAt.addingTimeInterval(activityTime)))
        
    }
    
    /**
     Is a safety verifier for the timeblock parameter. If the timeblock does not respect the margin time between two activities, the return will be a reduced version of itself.
     Precondition: self.canAllocateActivity(for: tbl) == true
     */
    private func getSubTimeBlockForNewActivity(from tbl: TimeBlock) -> TimeBlock {
        
        for activity in scheduledActivities {
            
            //if the tbl starts before the activity variable but does not respect the defined time between two activities
            if tbl.startsAt < activity.timeBlock.startsAt && tbl.endsAt.addingTimeInterval(secondsBetweenActivities) >= activity.timeBlock.startsAt {
                
                //make the timeblock smaller, to respect the time between itself and activity variable
                let newEnding = activity.timeBlock.startsAt.addingTimeInterval(-secondsBetweenActivities)
                
                //if the new ending of tbl1 is after the tbl1 starting (in other words, is not a "negative time"), returns it
                if newEnding > tbl.startsAt {
                    return TimeBlock(startsAt: tbl.startsAt, endsAt: newEnding)
                }
                
            //considering that the activity is before tbl, if it does not respect the defined time between two activities
            } else if activity.timeBlock.startsAt < tbl.startsAt && activity.timeBlock.endsAt.addingTimeInterval(secondsBetweenActivities) >= tbl.startsAt {
                
                //detect if tbl can be resized to support the distance between tbl and activity
                let newStarting = activity.timeBlock.endsAt.addingTimeInterval(secondsBetweenActivities)

                //if the new starting is not after the ending (is not "negative time"), returns the new time block
                if newStarting < tbl.endsAt {
                    return TimeBlock(startsAt: newStarting, endsAt: tbl.endsAt)
                }
                
            }
            
        }
        
        return tbl
        
    }
    
    /**
     Detect if can allocate a new activity for the timeblock tbl, considering the current activities and the
    */
    func canAllocateActivity(for tbl: TimeBlock) -> Bool {
        
        for activity in scheduledActivities {
            
            //if the time distance between the timeblock tbl and the activity is smaller than the allowed, should not allocate the activity for this timeblock
            if tbl.startsAt < activity.timeBlock.startsAt && tbl.endsAt.addingTimeInterval(secondsBetweenActivities) >= activity.timeBlock.startsAt {
                
                //detect if tbl can be resized to support the distance between tbl and activity
                let newEnding = activity.timeBlock.startsAt.addingTimeInterval(-secondsBetweenActivities)
                if newEnding <= tbl.startsAt {
                    return false
                }
                
            } else if activity.timeBlock.startsAt < tbl.startsAt && activity.timeBlock.endsAt.addingTimeInterval(secondsBetweenActivities) >= tbl.startsAt {

                //detect if tbl can be resized to support the distance between tbl and activity
                let newStarting = activity.timeBlock.endsAt.addingTimeInterval(secondsBetweenActivities)
                if newStarting >= tbl.endsAt {
                    return false
                }
                
            }
            
        }
        
        return true
        
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
