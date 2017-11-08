//
//  FoocoTests.swift
//  FoocoTests
//
//  Created by Victor S Melo on 20/10/17.
//
import XCTest
@testable import Fooco

class FoocoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
        
        Mocado.projects[0] = Project(named: "Mocado.projects[0]", startsAt: Mocado.today, endsAt: Mocado.tomorrow, withContext: Mocado.context1, importance: 1, totalTimeEstimated: 3_800)
        
        Mocado.projects[1] = Project(named: "Mocado.projects[1]", startsAt: Mocado.today, endsAt: Mocado.tomorrow, withContext: Mocado.context1, importance: 1, totalTimeEstimated: 8_000)
        
        
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
        Mocado.context1 = Context(named: "Mocado.context1", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: 3_200)
        
        let todayComponents = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let morningCblStart = dateFormatter.date(from: "\(Mocado.todayComponents.day!)-\(Mocado.todayComponents.month!)-\(Mocado.todayComponents.year!) 06:00:00")!
        let morningCblEnds = dateFormatter.date(from: "\(Mocado.todayComponents.day!)-\(Mocado.todayComponents.month!)-\(Mocado.todayComponents.year!) 10:00:00")!
        
        let defaultWeekday = Weekday(contextBlocks: [ContextBlock(timeBlock: TimeBlock(startsAt: morningCblStart, endsAt: morningCblEnds), context: Mocado.context1)])
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        Mocado.projects[0] = Project(named: "Mocado.projects[0]", startsAt: Mocado.today, endsAt: Mocado.tomorrow, withContext: Mocado.context1, importance: 1, totalTimeEstimated: 3_800)
        
        Mocado.projects[1] = Project(named: "Mocado.projects[1]", startsAt: Mocado.today, endsAt: Mocado.tomorrow, withContext: Mocado.context1, importance: 1, totalTimeEstimated: 8_000)
        
        
        user.add(contexts: [Mocado.context1])
        user.add(projects: [Mocado.projects[0]])
        user.add(projects: [Mocado.projects[1]])
        
        user.updateCurrentScheduleUntil(date: Mocado.tomorrow)
        
        XCTAssertTrue(Mocado.todayWeekday.contextBlocks[0].activities.count == 4)
        XCTAssertEqual(Mocado.todayWeekday.contextBlocks[0].activities[0].project.name, Mocado.projects[1].name)
        XCTAssertEqual(Mocado.todayWeekday.contextBlocks[0].activities[1].project.name, Mocado.projects[1].name)
        XCTAssertEqual(Mocado.todayWeekday.contextBlocks[0].activities[2].project.name, Mocado.projects[1].name)
        XCTAssertEqual(Mocado.todayWeekday.contextBlocks[0].activities[3].project.name, Mocado.projects[0].name)
        
        XCTAssertEqual(Mocado.projects[1].timeLeftEstimated, 0.0)
        XCTAssertTrue(Mocado.projects[0].timeLeftEstimated > 0.0)
        
    }
    
    func testTwoContextBlocksAndTwoProjects() {
        
        let user = User.sharedInstance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

        let today = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        
        let morningCblStart = dateFormatter.date(from: "\(Mocado.today.day!)-\(Mocado.today.month!)-\(Mocado.today.year!) 06:00:00")
        let morningCblEnds = dateFormatter.date(from: "\(Mocado.today.day!)-\(Mocado.today.month!)-\(Mocado.today.year!) 10:00:00")

        let afternoonCblStarts = dateFormatter.date(from: "\(Mocado.today.day!)-\(Mocado.today.month!)-\(Mocado.today.year!) 11:00:00")
        let afternoonCblEnds = dateFormatter.date(from: "\(Mocado.today.day!)-\(Mocado.today.month!)-\(Mocado.today.year!) 15:00:00")
        
        let college = Context(named: "college", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: nil)
        let work = Context(named: "work", color: UIColor.contextColors().first!, projects: nil, minProjectWorkingTime: nil, maximumWorkingHoursPerProject: nil)
        
        let morningCbl = ContextBlock(timeBlock: TimeBlock.init(startsAt: morningCblStart!, endsAt: morningCblEnds!), context: college)
        let afternoonCbl = ContextBlock(timeBlock: TimeBlock.init(startsAt: afternoonCblStarts!, endsAt: afternoonCblEnds!), context: work)
        
        let defaultWeekday = Weekday(contextBlocks: [morningCbl,afternoonCbl])
        
        user.weekSchedule = Week(sunday: defaultWeekday, monday: defaultWeekday, tuesday: defaultWeekday, wednesday: defaultWeekday, thursday: defaultWeekday, friday: defaultWeekday, saturday: defaultWeekday)
        
        let sixHours: TimeInterval = 21_600
        let fourDays: TimeInterval = 345_600
        let collegeProject = Project(named: "College Project", startsAt: Date(), endsAt: Date().addingTimeInterval(fourDays), withContext: college, importance: 2, totalTimeEstimated: sixHours)
        let workProject = Project(named: "Work Project", startsAt: Date(), endsAt: Date().addingTimeInterval(fourDays), withContext: work, importance: 3, totalTimeEstimated: sixHours)
        
        user.add(contexts: [college,work])
        user.add(projects: [collegeProject,workProject])
        
        user.updateCurrentScheduleUntil(date: Mocado.tomorrow)
        
    }
    
}


