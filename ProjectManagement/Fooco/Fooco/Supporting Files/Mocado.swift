//
//  Mocado.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

class Mocado {
	
	static let today = Date()
	static let tomorrow = Date().addingTimeInterval(1.day)
	
	static let todayComponents = Calendar.current.dateComponents([.day, .month, .year, .calendar], from: today)
	
	static var contexts = createContexts()
	static var projects = populateProjects()
    
    static let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: today, endsAt: Date().addingTimeInterval(5.hours)), context: contexts.random())])
	
    static let defaultWeek = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
	
	private static func createContexts() -> [Context] {
		let context1 = Context(named: "Context One", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: 3.hours)
		
		let context2 = Context(named: "Context Two", color: UIColor.contextColors().last!, projects: nil, minProjectWorkingTime: 1.hour, maximumWorkingHoursPerProject: 3.hours)
		
		return [context1, context2]
	}
	
    private static func populateProjects() -> [Project] {
        
        let proj1 = Project(named: "Project Test", startsAt: today, endsAt: Date().addingTimeInterval(21.days), withContext: contexts.first!, importance: 1, totalTimeEstimated: 30.hours)
        
        let proj2 = Project(named: "Test Two", startsAt: today, endsAt: Date().addingTimeInterval(30.days), withContext: contexts.last!, importance: 1, totalTimeEstimated: 40.hours)
        
        return [proj1, proj2]
    }
    
}
