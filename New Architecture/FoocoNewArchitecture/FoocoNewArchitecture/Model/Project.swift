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
    
    var priority: Priority {
        //TODO: implement get priority method
        return 0.0
    }
    
    init(name: String, starts: Date, ends: Date, context: Context, importance: Int) throws {
        self.name = name
        self.startingDate = starts
        self.endingDate = ends
        self.context = context
        
        if !Project.importanceRange.contains(importance) {
            
            throw ProjectError.InvalidImportanceValue("Importance value must be between 1 and 3. Current value is \(importance)")
            
        }
        
        self.importance = importance
        self.id = UUID()
    }
    
    /**
     Should be used internally just to load from database
     */
    private init(name: String, starts: Date, ends: Date, context: Context, importance: Int, id: UUID) {
        self.name = name
        self.startingDate = starts
        self.endingDate = ends
        self.context = context
        self.importance = importance
        self.id = id
    }
    
    /**
     - postcondition: returns nil if can not create an activity for the context block parameter
    */
    func nextActivity(for contextBlock: ContextBlock) -> Activity? {
        //TODO: implement nextActivity method
        
        //if can't create an activity for the context block (there is no sufficient time in the contextblock, for example), returns nil
        return nil
    }
    
}
