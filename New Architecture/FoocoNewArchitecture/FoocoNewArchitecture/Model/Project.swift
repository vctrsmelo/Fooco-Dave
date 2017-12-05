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

struct Project {
    
    static private let importanceRange: [Int] = [1,2,3]
    
    private let uuid: UUID
    private var name: String
    private var startingDate: Date
    private var endingDate: Date
    private var context: Context
    private var importance: Int
    
    init(name: String, starts: Date, ends: Date, context: Context, importance: Int) throws {
        self.name = name
        self.startingDate = starts
        self.endingDate = ends
        self.context = context
        
        if !Project.importanceRange.contains(importance) {
            
            throw ProjectError.InvalidImportanceValue("Importance value must be between 1 and 3. Current value is \(importance)")
            
        }
        
        self.importance = importance
        self.uuid = UUID()
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
        self.uuid = UUID()
    }
    
}
