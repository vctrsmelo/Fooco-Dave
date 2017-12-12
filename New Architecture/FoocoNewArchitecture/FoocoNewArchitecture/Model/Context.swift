//
//  Context.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 30/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class Context {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
}

extension Context: Equatable {
    static func ==(lhs: Context, rhs: Context) -> Bool {
        return lhs.name == rhs.name
    }
    
    
}
