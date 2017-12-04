//
//  Activity.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 04/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

/**
Activity is a period of time focusing in a task/project
*/
struct Activity {
    
    let id: UUID
    private let timeBlock: TimeBlock
    let project: Project?
    
    /**
     If the activity is not related to a project, it should have a name
    */
    let name: String?
    
    init(from: Time, to: Time, project: Project) throws {
        
        self.project = project
        self.name = nil
        self.timeBlock = try TimeBlock(starts: from, ends: to)
        id = UUID()
        
    }
    
    init(from: Time, to: Time, name: String) throws {
        
        self.project = nil
        self.name = name
        self.timeBlock = try TimeBlock(starts: from, ends: to)
        id = UUID()
        
    }
    
    /**
     Should be used internally just to load from database
    */
    private init(from: Time, to: Time, project: Project?, name: String?, id: UUID) throws {
        
        self.project = project
        self.name = name
        self.timeBlock = try TimeBlock(starts: from, ends: to)
        self.id = id
        
    }
    
}
