//
//  Context.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 30/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation
import UIKit

class Context {
    
    var name: String
    var color: UIColor
    var icon: UIImage
    
    init(name: String, color: UIColor, icon: UIImage) {
        self.name = name
        self.color = color
        self.icon = icon
    }
    
}

extension Context: Equatable {
    static func ==(lhs: Context, rhs: Context) -> Bool {
        return lhs.name == rhs.name
    }
    
    
}
