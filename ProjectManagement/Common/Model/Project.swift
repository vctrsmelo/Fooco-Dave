//
//  Project.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 04/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

enum ProjectError: Error {
    case invalidImportanceValue
}

extension ProjectError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidImportanceValue:
            return "Importance value should be 1, 2 or 3."
        }
    }
}


/**
 The priority value of a project.
 - Invariant: it's a value between 0 and 1. The closer to 1, the higher is the priority of the project.
*/
typealias Priority = Double

class Project: NSObject {
    
    static private let importanceRange: [Double] = [1.0, 2.0, 3.0]
    
    private let id: UUID
    var name: String
    var startingDate: Date
    var endingDate: Date
    var context: Context
    var importance: Double
    
    private var _initialEstimatedTime: TimeInterval
    private(set) var estimatedTime: TimeInterval
    
    var completedActivities: [(Activity, Date)]
    
    var observedActivities: [(Activity, NSKeyValueObservation)] = []

    //priority cached. When it's not valid anymore, should be setted to nil
    private var _priority: Priority?
    var priority: Priority {

        if _priority != nil {
            return _priority!
        }
        
        let et = self.estimatedTime
        let imp = self.importance
        let wat = User.sharedInstance.getWeeklyAvailableTime(for: self.context)
        
        //advRange is a value between 0 and 1. It is the percentage of how the time, since projecte beginning, has advanced closer to deadline.
        var advRange = getAdvRange()
        if advRange == 0.0 {
            advRange = 0.01
        }
        
        //there is no weekly available time for context. If that's the case, the project has no priority (it's impossible to be done while there is no time to work on it)
        if wat == 0 {

            return 0.0
        
        }
    
        _priority = (et * imp * advRange) / (wat * 3)
        return _priority!
        
    }
    
    init(name: String, starts: Date, ends: Date, context: Context, importance: Double, estimatedTime initialEstimatedTime: TimeInterval, completedActivities: [(Activity, Date)] = []) throws {
        
        self.name = name
        self.startingDate = starts
        self.endingDate = ends
        self.context = context
        
        if !Project.importanceRange.contains(importance) {
            
            throw ProjectError.invalidImportanceValue
            
        }
        
        self.estimatedTime = initialEstimatedTime
        self._initialEstimatedTime = initialEstimatedTime
        self.importance = importance
        self.completedActivities = completedActivities
        self.id = UUID()
        super.init()
        User.sharedInstance.addObserver(observer: self)
    }
    
    /**
     Should be used internally just to load from database
     */
    private init(name: String, starts: Date, ends: Date, context: Context, importance: Double, estimatedTime initialEstimatedTime: TimeInterval, completedActivities: [(Activity, Date)] = [], id: UUID) {
        self.name = name
        self.startingDate = starts
        self.endingDate = ends
        self.context = context
        self.importance = importance
        self.estimatedTime = initialEstimatedTime
        self._initialEstimatedTime = initialEstimatedTime
        self.completedActivities = completedActivities
        self.id = id
        super.init()
        User.sharedInstance.addObserver(observer: self)
    
    }
    
    
    /**
     Update the initial estimated time for the project.
     */
    func updateInitialEstimatedTime(_ timeInterval: TimeInterval) {
        
        _initialEstimatedTime = timeInterval
        update(with: User.sharedInstance.schedule)
        
    }
    
    private func addCompletedActivityObservation(for activity: Activity) {
        //becomes oberver of activity
        let observ = activity.observe(\.isCompleted) { activity, _ in
            if activity.isCompleted == true {
                self.completedActivities.append((activity, Date()))
                self.stopObserving(activity)
            }
        }
        
        self.observedActivities.append((activity, observ))
        
    }
    
    /**
     - parameter timeBlock: is the timeBlock considered available to be used for creating the Activity. The activity returned may have a time block smaller or equal to the parameter.
     - returns: maybe Activity.
     - postcondition: timeBlock.length < ActivityminimalTimeLength => result == nil
     - postcondition: self.estimatedTime <= 0 => result == nil
    */
    func nextActivity(for timeBlock: TimeBlock) -> Activity? {
        
        //verifies if timeBlock respects Activity.minimalTimeLength
        if timeBlock.length < Activity.minimalTimeLength {
            return nil
        }
        
        guard let activityTimeBlock = getTimeBlockForNewActivity(from: timeBlock) else {
            return nil
        }
        
        //return new activity created
        estimatedTime -= activityTimeBlock.length
        
        let activity = Activity(for: activityTimeBlock, project: self)
        
        addCompletedActivityObservation(for: activity)
        
        return activity
        
    }
  
    /**
     Compares the parameter timeBlock with Activity.minimalTimeLength and with self.estimatedTime to get the real time block for the activity that shall be created.
     - postcondition: result <= timeBlock OR result == nil
    */
    private func getTimeBlockForNewActivity(from timeBlock: TimeBlock) -> TimeBlock? {
        
        //verifies if exists left time to be completed (according to estimated time)
        let currentLeftTime = self.estimatedTime
        
        if currentLeftTime <= 0 {
            return nil
        }
        
        //left time to complete the project is smaller than timeBlock length
        if currentLeftTime < timeBlock.length {
            
            
            if currentLeftTime < Activity.minimalTimeLength {
                
                //activity should have length of Activity.minimalTimeLength
                return try! TimeBlock(starts: timeBlock.start, ends: timeBlock.start.addingTimeInterval(Activity.minimalTimeLength))
              
                
            }
            
            //activity should have length of currentLeftTime
            return try! TimeBlock(starts: timeBlock.start, ends: timeBlock.start.addingTimeInterval(currentLeftTime))

        }

        //activity should be created for timeBlock itself
        return timeBlock
        
    }
    
    /**
     - Returns:
        A value between 0 and 1 representing how closer the project is of the deadline. 1 means today is deadline date, and 0 means today is starting date.
    */
    private func getAdvRange() -> Double {
        
        let starts = startingDate.timeIntervalSince1970
        let ends = endingDate.timeIntervalSince1970
        let today = Date().timeIntervalSince1970
        
        var val = (today - starts) / (ends - starts)
        val = Double(round(1_000_000 * val) / 1_000_000)
        
        return val
        
    }
    
    /**
     - Returns:
        A value between 0 and 1 representing the project progress, according to the estimated time.
    */
    func getProgress() -> Double {
        
        return (_initialEstimatedTime - estimatedTime) / _initialEstimatedTime
        
    }
    
    /**
     Add activity to the completed activities list
     - Parameters:
        - activity: is the activity to be added into the completed activities list
        - date: is the date when activity was completed. If not defined, it will be the current date when this method is called.
    */
    func addCompletedActivity(_ activity: Activity, at date: Date = Date()) {
        
        self.completedActivities.append((activity, date))
        
    }
    
    /**
     - Returns:
     Sum of time length of the already completed activities.
     */
    func getCompletedActivitiesTotalLength() -> TimeInterval {
        
        var totalTime: TimeInterval = 0.0
        
        for activityAndDate in self.completedActivities {
            totalTime += activityAndDate.0.length
        }
        
        return totalTime
        
    }
    
    /**
     Remove the activity from current observed activities
    */
    func stopObserving(_ activity: Activity) {
        for i in 0 ..< self.observedActivities.count {
            if self.observedActivities[i].0 == activity {
                self.observedActivities.remove(at: i)
                break
            }
        }
    }
    
    /**
     When an activity is skipped this method should be called
    */
    func activitySkipped(_ activity: Activity) {
        
    }
    
}

extension Project: Observer {
    
    var observerId: UUID {
        return self.id
    }
    
    func update<T>(with newValue: T) {
        

        estimatedTime = _initialEstimatedTime - getCompletedActivitiesTotalLength()

        guard let schedule = newValue as? [Day] else {
            return
            
        }
        
        for activity in schedule.activities where activity.project == self {
            estimatedTime -= activity.length
        }
        
    }
    
    
}

//Equatable
extension Project {
    
    override func isEqual(_ object: Any?) -> Bool {
        return self.id == (object as? Project)?.id
    }
    
}

extension Project: Comparable {
    static func < (lhs: Project, rhs: Project) -> Bool {
        return lhs.priority > rhs.priority
    }
    
}
