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
        
        XCTAssertNoThrow(try Time(hour: 20))
        XCTAssertNoThrow(try Time(hour: 0, minute: 59))
        XCTAssertNoThrow(try Time(hour: 23, minute: 30, second: 59))
        
        XCTAssertEqual(try! Time(hour: 23),try! Time(hour: 23, minute: 0, second: 0))
        XCTAssertEqual(try! Time(hour: 10, minute: 15), try! Time(hour: 10, minute: 15, second: 0))
        XCTAssertEqual(try! Time(hour: 0), try! Time(hour: 0, minute: 0))
        
        XCTAssertNotEqual(try! Time(hour: 23), try! Time(hour:23, minute: 1))
        XCTAssertNotEqual(try! Time(hour: 23, minute: 20), try! Time(hour:23, minute: 20, second: 1))
        XCTAssertNotEqual(try! Time(hour: 23, minute: 0, second: 3), try! Time(hour:23, minute: 2, second: 3))
        
    }
    
    func testTimeBlock() {
        
        let t1 = try! Time(hour:20)
        let t2 = try! Time(hour:21)
        
        XCTAssertNotNil(try TimeBlock.init(starts: t1, ends: t2))
        XCTAssertThrowsError(try TimeBlock.init(starts: t2, ends: t1))
        
        let tb1 = try! TimeBlock.init(starts: t1, ends: t2)
        let tb2 = try! TimeBlock.init(starts: t1, ends: t2)
        
        XCTAssertTrue(tb1 == tb2)
        
        
    }
    
}
