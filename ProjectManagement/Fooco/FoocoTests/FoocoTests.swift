//
//  FoocoTests.swift
//  FoocoTests
//
//  Created by Victor S Melo on 20/10/17.
//
@testable import Fooco
import XCTest

class FoocoTests: XCTestCase {
    
//    func testUserGetNextProject() {
//        let user = User.sharedInstance
//        user.add(contexts: [Mocado.context1])
//        user.add(projects: [Mocado.projects[0]])
//
//        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock.init(startsAt: Date(), endsAt: Date().addingTimeInterval(10_800)), context: Mocado.context1)])
//        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
//
//
//        //1 project
//        XCTAssert(user.getNextProject(for: Mocado.context1) == Mocado.projects[0])
//
//        //2 projects
//        user.add(projects: [Mocado.projects[1]])
//        XCTAssert(user.getNextProject(for: Mocado.context1) == Mocado.projects[1])
//
//
//
//    }
    
    func testUserUpdateSchedule1ActivityToBeAllocated() {
        
        let user = User.sharedInstance
        
        user.add(contexts: [Mocado.context1])
        user.add(projects: [Mocado.projects[0]])
        user.add(projects: [Mocado.projects[1]])
        
        
        user.updateCurrentScheduleUntil(date: Mocado.tomorrow)
        
        guard let todayWeekday: Weekday = user.getSchedule(for: Mocado.today) else {
            print("[Error] did not find Mocado.todayWeekday")
            return
        }
        
        for cbl in todayWeekday.contextBlocks where cbl.context == Mocado.context1 {
            
            for act in cbl.activities {
                
                if act.project != Mocado.projects[1] {
                    
                }
                
                XCTAssertTrue(act.project.name == Mocado.projects[1].name)
            }
            
        }
        
    }
    
    //Should allocate both activities, prioritizing the Mocado.projects[1] activity.
    func testUserUpdateSchedule2ActivitiesToBeAllocated() {
        
        let user = User.sharedInstance
        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: Date(), endsAt: Date().addingTimeInterval(10_800)), context: Mocado.context1)])
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        Mocado.projects[0] = Project(named: "Mocado.projects[0]", startsAt: Mocado.today, endsAt: Mocado.tomorrow, withContext: Mocado.context1, importance: 1, totalTimeEstimated: 3800)
        
        Mocado.projects[1] = Project(named: "Mocado.projects[1]", startsAt: Mocado.today, endsAt: Mocado.tomorrow, withContext: Mocado.context1, importance: 1, totalTimeEstimated: 8000)
        
        
        user.add(contexts: [Mocado.context1])
        user.add(projects: [Mocado.projects[0]])
        user.add(projects: [Mocado.projects[1]])
        
        
        user.updateCurrentScheduleUntil(date: Mocado.tomorrow)
        
        guard let todayWeekday: Weekday = user.getSchedule(for: Mocado.today) else {
            print("[Error] did not find Mocado.todayWeekday")
            return
        }
        
        for cbl in todayWeekday.contextBlocks where cbl.context == Mocado.context1 {
            
            for act in cbl.activities {
                
                if act.project != Mocado.projects[1] {
                    
                }
                if cbl.activities.first!.project.name == act.project.name {
                    
                    XCTAssertTrue(act.project.name == Mocado.projects[1].name)
                } else {
                    
                    XCTAssertTrue(act.project.name == Mocado.projects[0].name)
                }
            }
            
        }
        
    }
    
    func testUserUpdateSchedule2ActivitiesToBeAllocatedWithMaxTime() {
        
        let user = User.sharedInstance
        Mocado.context1 = Context(named: "Mocado.context1", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: 3200)
		
        var dateComponents = DateComponents(calendar: Mocado.todayComponents.calendar!, year: Mocado.todayComponents.year!, month: Mocado.todayComponents.month!, day: Mocado.todayComponents.day!)
		
		dateComponents.hour = 6
        let morningCblStart = dateComponents.date!
		
		dateComponents.hour = 10
        let morningCblEnds = dateComponents.date!
        
        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: morningCblStart, endsAt: morningCblEnds), context: Mocado.context1)])
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        Mocado.projects[0] = Project(named: "Mocado.projects[0]", startsAt: Mocado.today, endsAt: Mocado.tomorrow, withContext: Mocado.context1, importance: 1, totalTimeEstimated: 3800)
        
        Mocado.projects[1] = Project(named: "Mocado.projects[1]", startsAt: Mocado.today, endsAt: Mocado.tomorrow, withContext: Mocado.context1, importance: 1, totalTimeEstimated: 8000)
        
        
        user.add(contexts: [Mocado.context1])
        user.add(projects: [Mocado.projects[0]])
        user.add(projects: [Mocado.projects[1]])
        
        user.updateCurrentScheduleUntil(date: Mocado.tomorrow)
        
        XCTAssertTrue(Mocado.defaultWeekday.contextBlocks[0].activities.count == 4)
        XCTAssertEqual(Mocado.defaultWeekday.contextBlocks[0].activities[0].project.name, Mocado.projects[1].name)
        XCTAssertEqual(Mocado.defaultWeekday.contextBlocks[0].activities[1].project.name, Mocado.projects[1].name)
        XCTAssertEqual(Mocado.defaultWeekday.contextBlocks[0].activities[2].project.name, Mocado.projects[1].name)
        XCTAssertEqual(Mocado.defaultWeekday.contextBlocks[0].activities[3].project.name, Mocado.projects[0].name)
		
        XCTAssertEqual(Mocado.projects[1].timeLeftEstimated, 0.0)
        XCTAssertTrue(Mocado.projects[0].timeLeftEstimated > 0.0)
        
    }
    
    func testTwoContextBlocksAndTwoProjects() {
        
        let user = User.sharedInstance
		
		var dateComponents = DateComponents(calendar: Mocado.todayComponents.calendar!, year: Mocado.todayComponents.year!, month: Mocado.todayComponents.month!, day: Mocado.todayComponents.day!)
		
		dateComponents.hour = 6
		let morningCblStart = dateComponents.date!
		
		dateComponents.hour = 10
        let morningCblEnds = dateComponents.date!

		dateComponents.hour = 11
        let afternoonCblStarts = dateComponents.date!
		
		dateComponents.hour = 15
        let afternoonCblEnds = dateComponents.date!
        
        let college = Context(named: "college", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: nil)
        let work = Context(named: "work", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: nil)
        
        let morningCbl = ContextBlock(timeBlock: TimeBlock(startsAt: morningCblStart, endsAt: morningCblEnds), context: college)
        let afternoonCbl = ContextBlock(timeBlock: TimeBlock(startsAt: afternoonCblStarts, endsAt: afternoonCblEnds), context: work)
        
        let defaultWeekday = Weekday(contextBlocks: [morningCbl, afternoonCbl])
        
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        let sixHours: TimeInterval = 21_600
        let fourDays: TimeInterval = 345_600
        let collegeProject = Project(named: "College Project", startsAt: Date(), endsAt: Date().addingTimeInterval(fourDays), withContext: college, importance: 2, totalTimeEstimated: sixHours)
        let workProject = Project(named: "Work Project", startsAt: Date(), endsAt: Date().addingTimeInterval(fourDays), withContext: work, importance: 3, totalTimeEstimated: sixHours)
        
        user.add(contexts: [college, work])
        user.add(projects: [collegeProject, workProject])
        
        user.updateCurrentScheduleUntil(date: Mocado.tomorrow)
        
    }
    
}
