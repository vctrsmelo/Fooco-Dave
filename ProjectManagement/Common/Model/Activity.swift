//
//  Activity.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 04/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

/**
Activity is a period of time focusing in a task/project, or an event from calendar.
 The sources for an activity are:
 - Project: defined during the scheduling algorithm
 - User input: through the interface
 - Calendar: through syncronization
*/
final class Activity: NSObject {
    
    // MARK: - Properties
    
    /**
     It's the minimal time length that a timeBlock can have. It's useful to avoid creating activities with smaller time lengths.
     */
    static let minimalTimeLength: TimeInterval = 25.minutes
    
    private let id: UUID
    let timeBlock: TimeBlock
    let project: Project?

    @objc private(set) dynamic var isCompleted: Bool
    /**
     If the activity is not related to a project, it should have a name
    */
    let name: String?
    
    // MARK: - Initialization
    
    init(for timeBlock: TimeBlock, project: Project, completed: Bool = false) {
        self.project = project
        self.name = nil
        self.timeBlock = timeBlock
        self.isCompleted = completed
        id = UUID()
    }
    
    init(for timeBlock: TimeBlock, name: String, completed: Bool = false) {
        self.name = name
        self.project = nil
        self.timeBlock = timeBlock
        self.isCompleted = completed
        id = UUID()
    }

    
    init(from: Time, to: Time, project: Project, completed: Bool = false) throws {
        
        self.project = project
        self.name = nil
        self.timeBlock = try TimeBlock(starts: from, ends: to)
        self.isCompleted = completed
        id = UUID()
        
    }
    
    init(from: Time, to: Time, name: String, completed: Bool = false) throws {
        
        self.name = name
        self.project = nil
        self.timeBlock = try TimeBlock(starts: from, ends: to)
        self.isCompleted = completed
        id = UUID()
        
    }
    
    /**
     Complete the current activity
    */
    func complete() {
        self.isCompleted = true
    }
    
    /**
     Should be used internally just to load from database
    */
    private init(from: Time, to: Time, project: Project?, name: String?, completed: Bool = false, id: UUID) throws {
        
        self.project = project
        self.name = name
        self.timeBlock = try TimeBlock(starts: from, ends: to)
        self.isCompleted = completed
        self.id = id
    }
    
}

extension Activity: IntervalType {
    
    typealias Bound = Time
    
    var end: Time {
        return timeBlock.end
    }
    
    var isEmpty: Bool {
        return timeBlock.isEmpty
    }
    
    var start: Time {
        return timeBlock.start
    }
    
    func clamp(_ intervalToClamp: Activity) -> Activity {

        let clampedTimeBlock = timeBlock.clamp(intervalToClamp.timeBlock)
        
        if self.project != nil {
            return try! Activity(from: clampedTimeBlock.start, to: clampedTimeBlock.end, project: self.project!)
        }
        
        return try! Activity(from: clampedTimeBlock.start, to: clampedTimeBlock.end, name: self.name!)
        
    }
    
    func contains(_ value: Time) -> Bool {
        return self.timeBlock.contains(value)
    }

    func contains<I>(_ other: I) -> Bool where I: IntervalType, Activity.Bound == I.Bound {
        return self.timeBlock.overlaps(other)
    }

    
    func overlaps<I>(_ other: I) -> Bool where I: IntervalType, Activity.Bound == I.Bound {
        return self.timeBlock.overlaps(other)
    }

    func getComplement(_ other: Activity) -> [Activity] {
        let complementedTimeBlocks = self.timeBlock.getComplement(other.timeBlock)
        
        var resultArray: [Activity] = []
        
        for compTbl in complementedTimeBlocks {
            
            if let name = self.name {
                resultArray.append(try! Activity(from: compTbl.start, to: compTbl.end, name: name))
                continue
            }
            
            if let project = self.project {
                resultArray.append(try! Activity(from: compTbl.start, to: compTbl.end, project: project))
            }
        }
        
        return resultArray
        
    }
    
}

extension Activity: TimeIntervalType {
    
    /**
     Activity's length in seconds.
    */
    var length: TimeInterval {
        return timeBlock.end - timeBlock.start
    }
    
    
}

//equatable
extension Activity {

    override func isEqual(_ object: Any?) -> Bool {
        return self.timeBlock == (object as? Activity)?.timeBlock
    }

}
