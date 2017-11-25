//
//  Context.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation
import UIKit

class Context: NSObject {
  
    var icon: UIImage?
    var name: String
    var projects: Set<Project>?
    var color: UIColor
    var minProjectWorkingTime: TimeInterval?
    var maxProjectWorkingTime: TimeInterval?

    init(named: String, color clr: UIColor = UIColor.contextColors().random(), icon icn: UIImage? = nil, projects projs: Set<Project>? = nil, minProjectWorkingTime min: TimeInterval?, maximumWorkingHoursPerProject max: TimeInterval?) {
        name = named
        projects = projs
        color = clr
        icon = icn
        minProjectWorkingTime = min
        maxProjectWorkingTime = max
    }

}
