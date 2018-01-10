//
//  ProjectManagementTests.swift
//  ProjectManagementTests
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

@testable import Fooco
import XCTest

class ProjectManagementTests: XCTestCase { // swiftlint:disable:this type_body_length

    let college = Context(name: "College", color: .blue, icon: UIImage())
    let work = Context(name: "Work", color: .red, icon: UIImage())

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        User.sharedInstance.updateAllProjects([])
        User.sharedInstance.contexts = []
        User.sharedInstance.schedule = nil
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTime() {

        XCTAssertThrowsError(try Time(hour: 40))
        XCTAssertThrowsError(try Time(hour: -1))
        XCTAssertThrowsError(try Time(hour: 2, minute: 60))
        XCTAssertThrowsError(try Time(hour: 2, minute: -1))
        XCTAssertThrowsError(try Time(hour: 2, minute: 21, second: 99))
        XCTAssertThrowsError(try Time(hour: 23, minute: 59, second: 60))
        XCTAssertThrowsError(try Time(day: 2, hour: 23, minute: 59, second: 60))

        XCTAssertNoThrow(try Time(hour: 20))
        XCTAssertNoThrow(try Time(hour: 0, minute: 59))
        XCTAssertNoThrow(try Time(hour: 23, minute: 30, second: 59))
        XCTAssertNoThrow(try Time(day: 59, hour: 23, minute: 30, second: 59))

        XCTAssertEqual(try! Time(hour: 23), try! Time(hour: 23, minute: 0, second: 0))
        XCTAssertEqual(try! Time(hour: 10, minute: 15), try! Time(hour: 10, minute: 15, second: 0))
        XCTAssertEqual(try! Time(hour: 0), try! Time(hour: 0, minute: 0))
        XCTAssertEqual(try! Time(day: 0, hour: 0), try! Time(hour: 0, minute: 0))

        XCTAssertNotEqual(try! Time(hour: 23), try! Time(hour: 23, minute: 1))
        XCTAssertNotEqual(try! Time(hour: 23, minute: 20), try! Time(hour: 23, minute: 20, second: 1))
        XCTAssertNotEqual(try! Time(hour: 23, minute: 0, second: 3), try! Time(hour: 23, minute: 2, second: 3))
        XCTAssertNotEqual(try! Time(day: 1, hour: 0), try! Time(hour: 0, minute: 0))


        //test hour, minute and second variables relation with totalSeconds
        var time = try! Time(hour: 20)
        XCTAssertTrue(time.hour * 60 * 60 + time.minute * 60 + time.second == Int(time.totalSeconds))
        time = try! Time(hour: 11, minute: 23, second: 59)
        XCTAssertTrue(time.hour * 60 * 60 + time.minute * 60 + time.second == Int(time.totalSeconds))
        time = try! Time(hour: 11, minute: 0, second: 30)
        XCTAssertTrue(time.hour * 60 * 60 + time.minute * 60 + time.second == Int(time.totalSeconds))
        time = try! Time(day: 3, hour: 0, minute: 0, second: 0)
        XCTAssertTrue(time.day * 24 * 60 * 60 + time.hour * 60 * 60 + time.minute * 60 + time.second == Int(time.totalSeconds))
        time = try! Time(day: 3, hour: 17, minute: 58, second: 23)
        XCTAssertTrue(time.day * 24 * 60 * 60 + time.hour * 60 * 60 + time.minute * 60 + time.second == Int(time.totalSeconds))

    }

    func testTimeBlock() {

        let t1 = try! Time(hour: 20)
        let t2 = try! Time(hour: 21)

        XCTAssertNotNil(try TimeBlock(starts: t1, ends: t2))

        //begins at the same time it ends (it is acceptable)
        XCTAssertNotNil(try TimeBlock(starts: t1, ends: t1))

        //begins after ends
        XCTAssertThrowsError(try TimeBlock(starts: t2, ends: t1))
        XCTAssertThrowsError(try TimeBlock(starts: try! Time(hour: 20, minute: 10), ends: try! Time(hour: 20, minute: 9)))
        XCTAssertThrowsError(try TimeBlock(starts: try! Time(hour: 20, minute: 10, second: 51), ends: try! Time(hour: 20, minute: 9, second: 50)))

        var tb1 = try! TimeBlock(starts: try! Time(hour: 20), ends: try! Time(hour: 22))
        XCTAssertThrowsError(try tb1.setStarts(try! Time(hour: 22, minute: 0, second: 1)))


        //equals time blocks
        XCTAssertTrue((try! TimeBlock(starts: t1, ends: t2)) == (try! (TimeBlock(starts: t1, ends: t2))))
        XCTAssertTrue((try! TimeBlock(starts: t1, ends: t2)) == (try! (TimeBlock(starts: (try! Time(hour: 20)), ends: (try! Time(hour: 21))))))
        XCTAssertTrue((try! TimeBlock(starts: t1, ends: t2)) != (try! (TimeBlock(starts: t1, ends: (try! Time(hour: 22))))))
        XCTAssertTrue((try! TimeBlock(starts: t1, ends: t2)) != (try! (TimeBlock(starts: (try! Time(hour: 19)), ends: t2))))

        //test overlaps and not contained
        var tb2 = try! TimeBlock(starts: try! Time(hour: 21), ends: try! Time(hour: 23))

        XCTAssertTrue(tb1.overlaps(tb2))
        XCTAssertTrue(tb2.overlaps(tb1))
        XCTAssertFalse(tb1.contains(tb2))
        XCTAssertFalse(tb2.contains(tb1))

        //test contains between time blocks

        tb1 = try! TimeBlock(starts: try! Time(hour: 20), ends: try! Time(hour: 23))
        tb2 = try! TimeBlock(starts: try! Time(hour: 21), ends: try! Time(hour: 22))

        let tb3 = try! TimeBlock(starts: try! Time(hour: 21), ends: try! Time(hour: 23))
        let tb4 = try! TimeBlock(starts: try! Time(hour: 20), ends: try! Time(hour: 22))

        XCTAssertTrue(tb1.contains(tb2))
        XCTAssertFalse(tb2.contains(tb1))
        XCTAssertTrue(tb1.contains(tb1))
        XCTAssertTrue(tb1.contains(tb3))
        XCTAssertTrue(tb1.contains(tb4))
        XCTAssertFalse(tb4.contains(tb3))

        //test contains with Time
        XCTAssertTrue(tb1.contains(try! Time(hour: 21, minute: 30)))
        XCTAssertTrue(tb1.contains(try! Time(hour: 21, minute: 0, second: 19)))
        XCTAssertTrue(tb1.contains(try! Time(hour: 20)))
        XCTAssertTrue(tb1.contains(try! Time(hour: 23)))
        XCTAssertFalse(tb1.contains(try! Time(hour: 23, minute: 0, second: 1)))
        XCTAssertFalse(tb1.contains(try! Time(hour: 19, minute: 59, second: 59)))

    }

    func testWeekdayTemplate() {

        XCTAssertNotNil(WeekdayTemplate(weekday: .sunday))
        XCTAssertNotNil(WeekdayTemplate(weekday: .monday))
        XCTAssertNotNil(WeekdayTemplate(weekday: .tuesday))
        XCTAssertNotNil(WeekdayTemplate(weekday: .wednesday))
        XCTAssertNotNil(WeekdayTemplate(weekday: .thursday))
        XCTAssertNotNil(WeekdayTemplate(weekday: .friday))
        XCTAssertNotNil(WeekdayTemplate(weekday: .saturday))

        let tb1 = try! TimeBlock(starts: try! Time(hour: 8), ends: try! Time(hour: 12))
        let college = Context(name: "College", color: .blue, icon: UIImage())

        XCTAssertNotNil(WeekdayTemplate(weekday: .monday, contextBlocks: [(tb1, college)]))
        XCTAssertNotNil(WeekdayTemplate(weekday: .tuesday, contextBlocks: [(tb1, college)]))

    }

    func testProjectCreation() {

        XCTAssertNoThrow(try Project(name: "App Development", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 5.hours))

    }

    func testProjectGetNextActivity() {

        let project = try! Project(name: "App Development", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 5.hours)

        XCTAssertNotNil(project.nextActivity(for: try! TimeBlock(starts: Time(hour: 2), ends: Time(hour: 4))))
        XCTAssertNotNil(project.nextActivity(for: try! TimeBlock(starts: Time(hour: 2), ends: Time(hour: 3))))
        XCTAssertNotNil(project.nextActivity(for: try! TimeBlock(starts: Time(hour: 2), ends: Time(hour: 2, minute: 25))))

        //Should return nil because TimeBlock parameter has smaller time length than Activity.minimalTimeLength
        XCTAssertNil(project.nextActivity(for: try! TimeBlock(starts: Time(hour: 2), ends: Time(hour: 2, minute: 24))))
        XCTAssertNil(project.nextActivity(for: try! TimeBlock(starts: Time(hour: 2), ends: Time(hour: 2, minute: 15))))
        XCTAssertNil(project.nextActivity(for: try! TimeBlock(starts: Time(hour: 2), ends: Time(hour: 2, minute: 1))))
        XCTAssertNil(project.nextActivity(for: try! TimeBlock(starts: Time(hour: 2), ends: Time(hour: 2, minute: 24, second: 59))))

        let completedProject = try! Project(name: "A Project already completed", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 0.hour)

        //Should return nil because project has zero estimated time left
        XCTAssertNil(completedProject.nextActivity(for: try! TimeBlock(starts: Time(hour: 2), ends: Time(hour: 10))))

        //should return activity with Activity.minimalTimeLength of size because the project.estimatedTime < Activity.minimalTimeLength
        let proj = try! Project(name: "Almost completed project", starts: Date(), ends: Date().addingTimeInterval(84_400), context: college, importance: 2, estimatedTime: 15.minutes)
        let tb = try! TimeBlock(starts: Time(hour: 10), ends: Time(hour: 11))
        XCTAssertEqual(proj.nextActivity(for: tb)!.length, Activity.minimalTimeLength)

        //should return activity with project.estimatedTime length
        let proj2 = try! Project(name: "Almost completed project", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 2, estimatedTime: 30.minutes)
        XCTAssertEqual(proj2.nextActivity(for: tb)?.length, 30.minutes)

    }

    func testDay() {

        let project1 = try! Project(name: "App Development", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 5.hours)
        let actv1 = try! Activity(from: Time(hour: 10), to: Time(hour: 12), name: "Buy milk")
        let actv2 = try! Activity(from: Time(hour: 13), to: Time(hour: 14), project: project1)

        XCTAssertNotNil(try Day(date: Date()))
        XCTAssertNoThrow(try Day(date: Date()))
        XCTAssertNotNil(try Day(date: Date().addingTimeInterval(86_400), activities: [actv1, actv2]))

        //test overlaps

        let actvA1 = try! Activity(from: Time(hour: 10), to: Time(hour: 14), project: project1)
        let actvA2 = try! Activity(from: Time(hour: 13), to: Time(hour: 15), project: project1)

        let actvB1 = try! Activity(from: Time(hour: 10), to: Time(hour: 14), project: project1)
        let actvB2 = try! Activity(from: Time(hour: 11), to: Time(hour: 12), project: project1)

        let actvC1 = try! Activity(from: Time(hour: 20), to: Time(hour: 21), project: project1)
        let actvC2 = try! Activity(from: Time(hour: 17), to: Time(hour: 21), project: project1)

        XCTAssertThrowsError(try Day(date: Date(), activities: [actvA1, actvA2]))
        XCTAssertThrowsError(try Day(date: Date(), activities: [actvB1, actvB2]))
        XCTAssertThrowsError(try Day(date: Date(), activities: [actvC1, actvC2]))
        XCTAssertThrowsError(try Day(date: Date(), activities: [actvC2, actvC2]))
        XCTAssertNoThrow(try Day(date: Date(), activities: [actvA1, actvC2]))


    }

    func testProjectPriorityCalculation() {

        //create weekTemplate for college
        let schedule = TestElementsGenerator.getWeekSchedule(contextAndDailyTime: [(college, 3.hours)])
        User.sharedInstance.weekTemplate = schedule

        //importance variation
        var p1 = try! Project(name: "most important", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 5.hours)
        var p2 = try! Project(name: "second most important", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 2, estimatedTime: 5.hours)
        var p3 = try! Project(name: "third most important", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 1, estimatedTime: 5.hours)

        var highestProjects = [p3, p1, p2]

        highestProjects.sort()

        XCTAssertEqual(highestProjects.first!, p1)
        XCTAssertEqual(highestProjects[1], p2)
        XCTAssertEqual(highestProjects.last!, p3)

        //starts and end difference time variation
        p1 = try! Project(name: "second most important", starts: Date().addingTimeInterval(-100_000), ends: Date().addingTimeInterval(100_000), context: college, importance: 2, estimatedTime: 3.hours)
        p2 = try! Project(name: "most important", starts: Date().addingTimeInterval(-100_000), ends: Date().addingTimeInterval(90_000), context: college, importance: 2, estimatedTime: 3.hours)
        p3 = try! Project(name: "third most important", starts: Date().addingTimeInterval(-100_000), ends: Date().addingTimeInterval(120_000), context: college, importance: 2, estimatedTime: 3.hours)

        highestProjects = [p3, p1, p2]
        highestProjects.sort()

        XCTAssertEqual(highestProjects.first!, p2)
        XCTAssertEqual(highestProjects[1], p1)
        XCTAssertEqual(highestProjects.last!, p3)

        //estimated time variation (if in the future, the user can change the prioritizing relating to estimated time, this test must be remade)
        p1 = try! Project(name: "third most important", starts: Date(), ends: Date().addingTimeInterval(120_000), context: college, importance: 2, estimatedTime: 1.hours)
        p2 = try! Project(name: "second most important", starts: Date(), ends: Date().addingTimeInterval(100_000), context: college, importance: 2, estimatedTime: 3.hours)
        p3 = try! Project(name: "most important", starts: Date(), ends: Date().addingTimeInterval(90_000), context: college, importance: 2, estimatedTime: 5.hours)

        highestProjects = [p3, p1, p2]
        highestProjects.sort()

        XCTAssertEqual(highestProjects.first!, p3)
        XCTAssertEqual(highestProjects[1], p2)
        XCTAssertEqual(highestProjects.last!, p1)

    }

    func testGetProjectsForContext() {

        User.sharedInstance.contexts = [college, work]

        let proj1College = try! Project(name: "Algebra test studying", starts: Date(), ends: Date().addingTimeInterval(3.day), context: college, importance: 3, estimatedTime: 8.hours)
        let proj2College = try! Project(name: "Programming Logic project", starts: Date().addingTimeInterval(-10.days), ends: Date().addingTimeInterval(10.day), context: college, importance: 3, estimatedTime: 15.hours)
        let proj3College = try! Project(name: "AI project", starts: Date().addingTimeInterval(-10.days), ends: Date().addingTimeInterval(20.day), context: college, importance: 3, estimatedTime: 25.hours)

        let proj1Work = try! Project(name: "Website for John's e-commerce", starts: Date(), ends: Date().addingTimeInterval(30.day), context: work, importance: 3, estimatedTime: 20.hours)
        let proj2Work = try! Project(name: "Presentation prepare for meeting with boss", starts: Date(), ends: Date().addingTimeInterval(10.day), context: work, importance: 2, estimatedTime: 3.hours)

        User.sharedInstance.add(projects: [proj1College, proj2College, proj3College, proj1Work, proj2Work])

        
        
        let collegeProjects = AlgorithmManager.getProjectsFor(context: college)
        let workProjects = AlgorithmManager.getProjectsFor(context: work)

        var c = 0
        for collegeProject in collegeProjects {
            switch collegeProject {
            case proj1College:
                c += 1

            case proj2College:
                c += 1

            case proj3College:
                c += 1

            default:
                break
            }
        }

        var w = 0
        for workProject in workProjects {
            switch workProject {
            case proj1Work:
                w += 1

            case proj2Work:
                w += 1

            default:
                break
            }
        }

        XCTAssertEqual(c, 3) //returned all college projects
        XCTAssertEqual(w, 2) //returned all work projects

    }

    func testGetAvailableTimeBlocksAndActivities() {

        let morningBlock = try! TimeBlock(starts: Time(hour: 8), ends: Time(hour: 11, minute: 30))

        let scheduler = ActivityScheduler(timeBlock: morningBlock, context: college)

        XCTAssertEqual(scheduler.getAvailableTimeBlocks(), [morningBlock])

        //add valid event
        let event1 = try! Activity(for: TimeBlock(starts: Time(hour: 9), ends: Time(hour: 10)), name: "student's meeting")
        XCTAssertNoThrow(try scheduler.add(activity: event1))

        XCTAssertEqual(scheduler.getActivities(), [event1]) //getActivities

        var getAvailableTimeBlocksCounter = 0
        for timeBlock in scheduler.getAvailableTimeBlocks() {
            switch timeBlock {
            case try! TimeBlock(starts: Time(hour: 8), ends: Time(hour: 9)):
                getAvailableTimeBlocksCounter += 1

            case try! TimeBlock(starts: Time(hour: 10), ends: Time(hour: 11, minute: 30)):
                getAvailableTimeBlocksCounter += 1

            default:
                break
            }
        }

        XCTAssertEqual(getAvailableTimeBlocksCounter, 2) //getAvailableTimeBlocks returned correct values

        //try to add event out of available time blocks (should not add)
        let event2 = try! Activity(for: TimeBlock(starts: Time(hour: 13), ends: Time(hour: 15)), name: "Get some papers into building A")
        XCTAssertThrowsError(try scheduler.add(activity: event2))

        //try to add event not fully contained into timeblock available (should not add)
        let event3 = try! Activity(for: TimeBlock(starts: Time(hour: 10), ends: Time(hour: 12)), name: "Something important but not fully contained into available timeblocks")
        XCTAssertThrowsError(try scheduler.add(activity: event3))

        XCTAssertEqual(scheduler.getActivities(), [event1])

        getAvailableTimeBlocksCounter = 0
        for timeBlock in scheduler.getAvailableTimeBlocks() {
            switch timeBlock {
            case try! TimeBlock(starts: Time(hour: 8), ends: Time(hour: 9)):
                getAvailableTimeBlocksCounter += 1

            case try! TimeBlock(starts: Time(hour: 10), ends: Time(hour: 11, minute: 30)):
                getAvailableTimeBlocksCounter += 1

            default:
                break
            }
        }

        XCTAssertEqual(getAvailableTimeBlocksCounter, 2) //getAvailableTimeBlocks still returned correct values


    }

    func testGetWeekdayTemplate() {

        //create weekTemplate for college
        let schedule = TestElementsGenerator.getWeekSchedule(contextAndDailyTime: [(college, 3.hours)])
        User.sharedInstance.weekTemplate = schedule

        let testMonday = try! WeekdayTemplate(weekday: .monday, contextBlocks: [(TimeBlock(starts: Time(hour: 10), ends: Time(hour: 20)), work)])
        User.sharedInstance.weekTemplate.value.1 = testMonday

        let takenMonday = User.sharedInstance.getWeekdayTemplate(for: .monday)

        //test getting the weekday that was added into user weekTemplate
        XCTAssertEqual(testMonday, takenMonday)

        let takenTuesday = User.sharedInstance.getWeekdayTemplate(for: .tuesday)

        //test getting another weekday
        XCTAssertNotEqual(testMonday, takenTuesday)

    }

    func testGetDayScheduleForDate() {

        //create weekTemplate for college
        var schedule = TestElementsGenerator.getWeekSchedule(contextAndDailyTime: [(college, 3.hours)])
        User.sharedInstance.weekTemplate = schedule

        let project1 = try! Project(name: "Algebra Project", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 5.hours)

        User.sharedInstance.add(project: project1)
        User.sharedInstance.schedule = try! AlgorithmManager.getDayScheduleFor(date: Date().addingTimeInterval(1.day))

        XCTAssertEqual(User.sharedInstance.schedule!.count, 2)

        for day in User.sharedInstance.schedule! {
            for activity in day.activities {

                XCTAssertEqual(activity.project, project1)

            }
        }

        XCTAssertEqual(project1.estimatedTime, 0)

        //project does not return new activity when it has already allocated all activities
        XCTAssertNil(try! project1.nextActivity(for: TimeBlock(starts: Time(hour: 0), ends: Time(hour: 23, minute: 59))))

        schedule = TestElementsGenerator.getWeekSchedule(contextAndDailyTime: [(college, 3.hours), (work, 4.hours)])
        User.sharedInstance.weekTemplate = schedule
        User.sharedInstance.schedule = nil
        User.sharedInstance.updateAllProjects([])

        let projCollege = try! Project(name: "College Project", starts: Date().addingTimeInterval(-1.day), ends: Date().addingTimeInterval(10.days), context: college, importance: 2, estimatedTime: 10.hours)

        let projWork = try! Project(name: "Work Project", starts: Date(), ends: Date().addingTimeInterval(20.days), context: work, importance: 3, estimatedTime: 20.hours)

        User.sharedInstance.add(projects: [projCollege, projWork])
        User.sharedInstance.schedule = try! AlgorithmManager.getDayScheduleFor(date: Date().addingTimeInterval(3.days))

        XCTAssertEqual(User.sharedInstance.schedule!.count, 4)

        for day in User.sharedInstance.schedule! {
            for activity in day.activities {

                let proj = activity.project!
                XCTAssertTrue((proj.context == work && proj == projWork) || (proj.context == college && proj == projCollege))

            }
        }

    }

    func testProjectProgress() {

        let proj = try! Project(name: "Algebra Project", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 10.hours)

        _ = try! proj.nextActivity(for: TimeBlock(starts: Time(hour: 0), ends: Time(hour: 5)))

        XCTAssertEqual(proj.estimatedTime, 5.hours)
        XCTAssertEqual(proj.getProgress(), 0.5)

         _ = try! proj.nextActivity(for: TimeBlock(starts: Time(hour: 0), ends: Time(hour: 5)))

        XCTAssertEqual(proj.estimatedTime, 0.hours)
        XCTAssertEqual(proj.getProgress(), 1)

    }

    func testGetCompletedActivities() {

        //create weekTemplate for college
        let schedule = TestElementsGenerator.getWeekSchedule(contextAndDailyTime: [(college, 5.hours)])
        User.sharedInstance.weekTemplate = schedule

        let project1 = try! Project(name: "Algebra Project", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 5.hours)

        User.sharedInstance.updateAllProjects([project1])
        User.sharedInstance.schedule = try! AlgorithmManager.getDayScheduleFor(date: Date().addingTimeInterval(1.day))

        XCTAssertEqual(User.sharedInstance.schedule!.count, 2)

        for day in User.sharedInstance.schedule! {
            for activity in day.activities {

                XCTAssertEqual(activity.project, project1)

            }
        }

        let activity1 = User.sharedInstance.schedule!.activities.first!

        activity1.complete()

        //assert that the project1 knows the activity was completed
        XCTAssertTrue(project1.completedActivities.contains { activity1 -> Bool in

            for actvAndDate in project1.completedActivities where actvAndDate.0 == activity1.0 {
                return true
            }

            return false
        })

        //as the activity1 is completed, the project1 should stop observing it.
        XCTAssertEqual(project1.observedActivities.count, 0)
    }
    
    func testUserSkipActivity() {
        
        //create weekTemplate for college
        let schedule = TestElementsGenerator.getWeekSchedule(contextAndDailyTime: [(college, 4.hours),(work,8.hour)])
        User.sharedInstance.weekTemplate = schedule
        
        let project1 = try! Project(name: "Algebra Project", starts: Date(), ends: Date().addingTimeInterval(86_400), context: college, importance: 3, estimatedTime: 4.hours)
        
        User.sharedInstance.add(projects: [project1])
        User.sharedInstance.schedule = try! AlgorithmManager.getDayScheduleFor(date: Date().addingTimeInterval(1.day))
        XCTAssertEqual(User.sharedInstance.schedule!.count, 2)
        
        

        
    }
    
} // swiftlint:disable:this file_length
