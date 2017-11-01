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
  
    var name: String
    var projects: Set<Project>?
    var color: UIColor
    var minimalWorkingTimePerProject: TimeInterval?
    var maximumWorkingTimePerProject: TimeInterval?
    
    init(named: String, color clr: UIColor = UIColor.contextColors().random(), projects projs: Set<Project>? = nil, minimalWorkingTimePerProject min: TimeInterval?, maximumWorkingHoursPerProject max: TimeInterval?) {
        name = named
        projects = projs
        color = clr
        minimalWorkingTimePerProject = min
        maximumWorkingTimePerProject = max
    }

}

extension UIColor {
    
    static func interfaceColors() -> [UIColor]{
        
        return [#colorLiteral(red: 0.2171623707, green: 0.4459149837, blue: 0.5379145741, alpha: 1),#colorLiteral(red: 0.3586075306, green: 0.7084770203, blue: 0.610791266, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 0.6141311526, green: 0.8158430457, blue: 0.5836192369, alpha: 1),#colorLiteral(red: 0.0337530449, green: 0.1313122213, blue: 0.2268140912, alpha: 1)]
        
        
    }
    
    static func contextColors() -> [UIColor]{
        
        return [#colorLiteral(red: 0.003921568627, green: 0.9046495226, blue: 1, alpha: 1),#colorLiteral(red: 0.01016705018, green: 0.9892892241, blue: 0.0263005197, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]
        
    }
    
}

extension Array {
    
    func random(from: Int? = nil, to: Int? = nil) -> Element {

        let begin = ((from == nil || from! > to!) ? 0 : from)!              //if "from" is nil, begin = 0
        let end = ((to == nil || to! > (self.count)) ? self.count : to)!    //if "to" is nil, end = self.count
        
        let i = end-begin   //difference between end and begin
        
        var randomIndex = Int(arc4random_uniform(UInt32(i)))
        randomIndex += begin    //move "begin" values to the right
        
        return self[randomIndex]
        
    }
    
}
