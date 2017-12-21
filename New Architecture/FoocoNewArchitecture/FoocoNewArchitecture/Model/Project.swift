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
    
    static private let importanceRange: [Int] = [1,2,3]
    
    private let id: UUID
    var name: String
    private var startingDate: Date
    private var endingDate: Date
    private(set) var context: Context
    private var importance: Int
    
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
        
        //TODO: implement get priority method
        return 0.0
    }
    
    init(name: String, starts: Date, ends: Date, context: Context, importance: Int, estimatedTime notAllocatedLeftTime: TimeInterval) throws {
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
    private init(name: String, starts: Date, ends: Date, context: Context, importance: Int, estimatedTime notAllocatedLeftTime: TimeInterval, id: UUID) {
        self.name = name
        self.startingDate = starts
        self.endingDate = ends
        self.context = context
        self.importance = importance
        self._notAllocatedEstimatedTime = notAllocatedLeftTime
        self.id = id
    }
    
    /**
     - postcondition: returns nil if can not create an activity for the time block parameter
    */
    func nextActivity(for timeBlock: TimeBlock) -> Activity? {
        
        //TODO: implement nextActivity method
        
        //verifies if timeBlock respects Activity.minimalTimeLength
        if timeBlock.length < Activity.minimalTimeLength {
            return nil
        }
        
        //verifies if exists left time to be completed (according to estimated time)
        let currentLeftTime = self.estimatedTime
        
        if currentLeftTime <= 0 {
            return nil
        }
        
        //return new activity created
        return Activity(for: timeBlock, project: self)
        
    }
    
}

extension Project: Equatable {
    
    static func ==(lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
    
}
