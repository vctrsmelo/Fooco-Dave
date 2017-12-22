//
//  Project.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 04/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

enum ProjectError: Error {
    case InvalidImportanceValue(String)
}

/**
 The priority value of a project.
 - Invariant: it's a value between 0 and 1. The closer to 1, the higher is the priority of the project.
*/
typealias Priority = Double

class Project {
    
    static private let importanceRange: [Double] = [1.0,2.0,3.0]
    
    private let id: UUID
    var name: String
    private var startingDate: Date
    private var endingDate: Date
    private(set) var context: Context
    private var importance: Double
    
    private var _notAllocatedEstimatedTime: TimeInterval
    private var estimatedTime: TimeInterval {
        var leftTime = _notAllocatedEstimatedTime
        
        //if user has an schedule in cache
        if let schedule = User.sharedInstance.schedule {
        
            //for each day in schedule
            for day in schedule {
                
                //for each activity in day
                for activity in day.activities {
                    
                    //remove the time of activities already scheduled
                    if activity.project == self {
                        leftTime -= activity.length
                    }
                    
                }
            }
        }
        return leftTime
    }

    //priority cached. When it's not valid anymore, should be setted to nil
    private var _priority: Priority?
    var priority: Priority {

        if _priority != nil {
            return _priority!
        }
        
        let et = self.estimatedTime
        let imp = self.importance
        let wat = User.sharedInstance.getWeeklyAvailableTime(for: self.context)
        
        //there is no weekly available time for context. If that's the case, the project has no priority (it's impossible to be done while there is no time to work on it)
        if wat == 0 {

            return 0.0
        
        }
        
        _priority = (et*imp)/(wat*3)
        return _priority!
        
    }
    
    init(name: String, starts: Date, ends: Date, context: Context, importance: Double, estimatedTime notAllocatedLeftTime: TimeInterval) throws {
        self.name = name
        self.startingDate = starts
        self.endingDate = ends
        self.context = context
        
        if !Project.importanceRange.contains(importance) {
            
            throw ProjectError.InvalidImportanceValue("Importance value must be between 1 and 3. Current value is \(importance)")
            
        }
        
        self._notAllocatedEstimatedTime = notAllocatedLeftTime
        
        self.importance = importance
        self.id = UUID()
    }
    
    /**
     Should be used internally just to load from database
     */
    private init(name: String, starts: Date, ends: Date, context: Context, importance: Double, estimatedTime notAllocatedLeftTime: TimeInterval, id: UUID) {
        self.name = name
        self.startingDate = starts
        self.endingDate = ends
        self.context = context
        self.importance = importance
        self._notAllocatedEstimatedTime = notAllocatedLeftTime
        self.id = id
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
        return Activity(for: activityTimeBlock, project: self)
        
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
    
}

extension Project: Equatable {
    
    static func ==(lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
    
}
