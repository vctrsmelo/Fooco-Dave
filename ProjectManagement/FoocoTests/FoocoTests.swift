//
//  FoocoTests.swift
//  FoocoTests
//
//  Created by Victor S Melo on 20/10/17.
//
import XCTest
@testable import Fooco

class FoocoTests: XCTestCase {
    
    let today: Date! = Date()
    let tomorrow: Date! = Date().addingTimeInterval(86_400)
    var context1: Context!
    var proj1: Project!
    var proj2: Project!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        context1 = Context(named: "context1", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: nil)
        proj1 = Project(named: "proj1", startsAt: today, endsAt: tomorrow, withContext: context1, andPriority: 1, totalTimeEstimated: 7_200)
        
        proj2 = Project(named: "proj2", startsAt: today, endsAt: tomorrow, withContext: context1, andPriority: 1, totalTimeEstimated: 10_800)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func testUserGetNextProject() {
//        let user = User.sharedInstance
//        user.add(contexts: [context1])
//        user.add(projects: [proj1])
//
//        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock.init(startsAt: Date(), endsAt: Date().addingTimeInterval(10_800)), context: context1)])
//        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
//
//
//        //1 project
//        XCTAssert(user.getNextProject(for: context1) == proj1)
//
//        //2 projects
//        user.add(projects: [proj2])
//        XCTAssert(user.getNextProject(for: context1) == proj2)
//
//
//
//    }
    
    func testUserUpdateSchedule() {
        
        let user = User.sharedInstance
        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: Date(), endsAt: Date().addingTimeInterval(10_800)), context: context1)])
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        user.add(contexts: [context1])
        user.add(projects: [proj1])
        user.add(projects: [proj2])
        
        XCTAssert(user.getNextProject(for: context1) == proj2)
        
        
        user.updateCurrentScheduleUntil(date: tomorrow)
        
        let todayWeekday: Weekday = user.getSchedule(for: today)!
        
        for cbl in todayWeekday.contextBlocks where cbl.context == context1 {
            
            for act in cbl.activities {
                
                if act.project != proj2 {
                    
                }
                
                XCTAssertTrue(act.project == proj2)
            }
            
        }
        
    }
    
}


