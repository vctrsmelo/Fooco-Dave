//
//  Mocado.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import Foundation
import UIKit

class Mocado {
    
    static var projects: [Project] = Mocado.populateProjects()
    static let today: Date! = Date()
    static let tomorrow: Date! = Date().addingTimeInterval(86_400)
    
    static let context1: Context = Context(named: "context1", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: 3_200)
    
    static let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: Date(), endsAt: Date().addingTimeInterval(10_800)), context: context1)])
    
    static let defaultWeek = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
    
    static private func populateProjects() -> [Project] {
        
        let proj1 = Project(named: "proj1", startsAt: today, endsAt: tomorrow, withContext: context1, importance: 1, totalTimeEstimated: 7_200)
        
        let proj2 = Project(named: "proj2", startsAt: today, endsAt: tomorrow, withContext: context1, importance: 1, totalTimeEstimated: 10_800)
        
        return [proj1,proj2]
        
    }
    
}
