//
//  FoocoNewArchitectureTests.swift
//  FoocoNewArchitectureTests
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import XCTest
@testable import FoocoNewArchitecture

class FoocoNewArchitectureTests: XCTestCase {
    
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
    
    func testTime() {
        
        XCTAssertThrowsError(try Time(hour: 40))
        XCTAssertThrowsError(try Time(hour: -1))
        XCTAssertThrowsError(try Time(hour: 2, minute: 60))
        XCTAssertThrowsError(try Time(hour: 2, minute: -1))
        XCTAssertThrowsError(try Time(hour: 2, minute: 21, second: 99))
        XCTAssertThrowsError(try Time(hour: 23, minute: 59, second: 60))
        
        XCTAssertNoThrow(try Time(hour: 20))
        XCTAssertNoThrow(try Time(hour: 0, minute: 59))
        XCTAssertNoThrow(try Time(hour: 23, minute: 30, second: 59))
        
        XCTAssertEqual(try! Time(hour: 23),try! Time(hour: 23, minute: 0, second: 0))
        XCTAssertEqual(try! Time(hour: 10, minute: 15), try! Time(hour: 10, minute: 15, second: 0))
        XCTAssertEqual(try! Time(hour: 0), try! Time(hour: 0, minute: 0))
        
        XCTAssertNotEqual(try! Time(hour: 23), try! Time(hour:23, minute: 1))
        XCTAssertNotEqual(try! Time(hour: 23, minute: 20), try! Time(hour:23, minute: 20, second: 1))
        XCTAssertNotEqual(try! Time(hour: 23, minute: 0, second: 3), try! Time(hour:23, minute: 2, second: 3))
        
        //test hour, minute and second variables relation with totalSeconds
        var time = try! Time(hour: 20)
        XCTAssertTrue(time.hour*60*60+time.minute*60+time.second == Int(time.totalSeconds))
        time = try! Time(hour: 11, minute: 23, second: 59)
        XCTAssertTrue(time.hour*60*60+time.minute*60+time.second == Int(time.totalSeconds))
        time = try! Time(hour: 11, minute: 0, second: 30)
        XCTAssertTrue(time.hour*60*60+time.minute*60+time.second == Int(time.totalSeconds))
        
    }
    
    func testTimeBlock() {
        
        let t1 = try! Time(hour:20)
        let t2 = try! Time(hour:21)
        
        XCTAssertNotNil(try TimeBlock.init(starts: t1, ends: t2))
        
        //begins at the same time it ends (it is acceptable)
        XCTAssertNotNil(try TimeBlock.init(starts: t1, ends: t1))
        
        //begins after ends
        XCTAssertThrowsError(try TimeBlock.init(starts: t2, ends: t1))
        XCTAssertThrowsError(try TimeBlock.init(starts: try! Time(hour: 20, minute: 10), ends: try! Time(hour: 20, minute: 9)))
        XCTAssertThrowsError(try TimeBlock.init(starts: try! Time(hour: 20, minute: 10, second: 51), ends: try! Time(hour: 20, minute: 9, second: 50)))

        var tb1 = try! TimeBlock(starts: try! Time(hour: 20), ends: try! Time(hour: 22))
        XCTAssertThrowsError(try tb1.setStarts(try! Time(hour: 22, minute: 0, second: 1)))
        
        
        //equals time blocks
        XCTAssertTrue((try! TimeBlock.init(starts: t1, ends: t2)) == (try! (TimeBlock.init(starts: t1, ends: t2))))
        XCTAssertTrue((try! TimeBlock.init(starts: t1, ends: t2)) == (try! (TimeBlock.init(starts: (try! Time(hour: 20)), ends: (try! Time(hour: 21))))))
        XCTAssertTrue((try! TimeBlock.init(starts: t1, ends: t2)) != (try! (TimeBlock.init(starts: t1, ends: (try! Time(hour: 22))))))
        XCTAssertTrue((try! TimeBlock.init(starts: t1, ends: t2)) != (try! (TimeBlock.init(starts: (try! Time(hour: 19)), ends: t2))))
        
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
        let college = Context(name: "College")
        
        XCTAssertNotNil(WeekdayTemplate(weekday: .monday, contextBlocks: [(tb1,college)]))
        XCTAssertNotNil(WeekdayTemplate(weekday: .tuesday, contextBlocks: [(tb1,college)]))
        
        
        
    }
    
}
