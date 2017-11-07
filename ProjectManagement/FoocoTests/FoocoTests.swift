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
    
    func testUserUpdateSchedule1ActivityToBeAllocated() {
        
        let user = User.sharedInstance
        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: Date(), endsAt: Date().addingTimeInterval(10_800)), context: context1)])
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        user.add(contexts: [context1])
        user.add(projects: [proj1])
        user.add(projects: [proj2])
        
        XCTAssert(user.getNextProject(for: context1) == proj2)
        
        
        user.updateCurrentScheduleUntil(date: tomorrow)
        
        guard let todayWeekday: Weekday = user.getSchedule(for: today) else {
            print("[Error] did not find todayWeekday")
            return
        }
        
        for cbl in todayWeekday.contextBlocks where cbl.context == context1 {
            
            for act in cbl.activities {
                
                if act.project != proj2 {
                    
                }
                
                XCTAssertTrue(act.project.name == proj2.name)
            }
            
        }
        
    }
    
    //Should allocate both activities, prioritizing the proj2 activity.
    func testUserUpdateSchedule2ActivitiesToBeAllocated() {
        
        let user = User.sharedInstance
        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: Date(), endsAt: Date().addingTimeInterval(10_800)), context: context1)])
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        proj1 = Project(named: "proj1", startsAt: today, endsAt: tomorrow, withContext: context1, andPriority: 1, totalTimeEstimated: 3_800)
        
        proj2 = Project(named: "proj2", startsAt: today, endsAt: tomorrow, withContext: context1, andPriority: 1, totalTimeEstimated: 8_000)
        
        
        user.add(contexts: [context1])
        user.add(projects: [proj1])
        user.add(projects: [proj2])
        
        XCTAssert(user.getNextProject(for: context1) == proj2)
        
        
        user.updateCurrentScheduleUntil(date: tomorrow)
        
        guard let todayWeekday: Weekday = user.getSchedule(for: today) else {
            print("[Error] did not find todayWeekday")
            return
        }
        
        for cbl in todayWeekday.contextBlocks where cbl.context == context1 {
            
            for act in cbl.activities {
                
                if act.project != proj2 {
                    
                }
                if cbl.activities.first!.project.name == act.project.name {
                    
                    XCTAssertTrue(act.project.name == proj2.name)
                } else {
                    
                    XCTAssertTrue(act.project.name == proj1.name)
                }
            }
            
        }
        
    }
    
    func testUserUpdateSchedule2ActivitiesToBeAllocatedWithMaxTime() {
        
        let user = User.sharedInstance
        context1 = Context(named: "context1", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: 3_200)
        
        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: Date(), endsAt: Date().addingTimeInterval(10_800)), context: context1)])
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        proj1 = Project(named: "proj1", startsAt: today, endsAt: tomorrow, withContext: context1, andPriority: 1, totalTimeEstimated: 3_800)
        
        proj2 = Project(named: "proj2", startsAt: today, endsAt: tomorrow, withContext: context1, andPriority: 1, totalTimeEstimated: 8_000)
        
        
        user.add(contexts: [context1])
        user.add(projects: [proj1])
        user.add(projects: [proj2])
        
        XCTAssert(user.getNextProject(for: context1) == proj2)
        
        
        user.updateCurrentScheduleUntil(date: tomorrow)
        
        guard let todayWeekday: Weekday = user.getSchedule(for: today) else {
            print("[Error] did not find todayWeekday")
            return
        }
        
        XCTAssertTrue(todayWeekday.contextBlocks[0].activities.count == 4)
        XCTAssertEqual(todayWeekday.contextBlocks[0].activities[0].project.name, proj2.name)
        XCTAssertEqual(todayWeekday.contextBlocks[0].activities[1].project.name, proj2.name)
        XCTAssertEqual(todayWeekday.contextBlocks[0].activities[2].project.name, proj2.name)
        XCTAssertEqual(todayWeekday.contextBlocks[0].activities[3].project.name, proj1.name)
        
        XCTAssertEqual(proj2.timeLeftEstimated, 0.0)
        XCTAssertTrue(proj1.timeLeftEstimated > 0.0)
        
    }
    
    func testTwoContextBlocksAndTwoProjects() {
        
        let user = User.sharedInstance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

        let today = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        
        let morningCblStart = dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!) 06:00:00")
        let morningCblEnds = dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!) 10:00:00")

        let afternoonCblStarts = dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!) 11:00:00")
        let afternoonCblEnds = dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!) 15:00:00")
        
        let college = Context(named: "college", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: nil)
        let work = Context(named: "work", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: nil)
        
        let morningCbl = ContextBlock(timeBlock: TimeBlock.init(startsAt: morningCblStart!, endsAt: morningCblEnds!), context: college)
        let afternoonCbl = ContextBlock(timeBlock: TimeBlock.init(startsAt: afternoonCblStarts!, endsAt: afternoonCblEnds!), context: work)
        
        let defaultWeekday = Weekday(contextBlocks: [morningCbl,afternoonCbl])
        
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        let sixHours: TimeInterval = 21_600
        let fourDays: TimeInterval = 345_600
        let collegeProject = Project(named: "College Project", startsAt: Date(), endsAt: Date().addingTimeInterval(fourDays), withContext: college, andPriority: 2, totalTimeEstimated: sixHours)
        let workProject = Project(named: "Work Project", startsAt: Date(), endsAt: Date().addingTimeInterval(fourDays), withContext: work, andPriority: 3, totalTimeEstimated: sixHours)
        
        user.add(contexts: [college,work])
        user.add(projects: [collegeProject,workProject])
        
        user.updateCurrentScheduleUntil(date: tomorrow)
        
        
    }
    
}


