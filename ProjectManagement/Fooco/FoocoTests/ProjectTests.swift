//
//  ProjectTests.swift
//  FoocoTests
//
//  Created by Victor S Melo on 27/10/17.
//

import XCTest

class ProjectTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPriorityCalculation() {
        
//        let ctx = Context(named: "Context1", color: UIColor.contextColors()[0], projects: [], minimalWorkingTimePerProject: 60*60, maximumWorkingHoursPerProject: 60*60*24)
//        var proj = Project.init(named: "proj1", startsAt: Date(), endsAt: Date().addingTimeInterval(86400), withContext: ctx, totalTimeEstimated: 60*60*48)
//
////        XCTAssert
//        print("priority: \(proj.getPriorityValue())")
        
    }
    
}
