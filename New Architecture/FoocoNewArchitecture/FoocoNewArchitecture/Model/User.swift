//
//  User.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 05/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

struct User {
    
    static let sharedInstance = User()
    
    var projects: [Project]
    var contexts: [Context]
    
    var schedule: [Date:[Activity]]
    
    private init(projects: [Project] = [], contexts: [Context] = [], schedule: [Date:[Activity]] = [:]) {
        self.projects = projects
        self.contexts = contexts
        self.schedule = schedule
    }
    
}
