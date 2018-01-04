//
//  TestElementsGenerator.swift
//  FoocoNewArchitectureTests
//
//  Created by Victor S Melo on 22/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

@testable import Fooco
import Foundation

class TestElementsGenerator {
    
    
    /**
     - Returns: weekly schedule with only one daily context block for each context parameter.
    */
    static func getWeekSchedule(contextAndDailyTime: [(Context, TimeInterval)]) -> WeekTemplate {

        var sun = WeekdayTemplate(weekday: .sunday)
        var mon = WeekdayTemplate(weekday: .monday)
        var tue = WeekdayTemplate(weekday: .tuesday)
        var wed = WeekdayTemplate(weekday: .wednesday)
        var thu = WeekdayTemplate(weekday: .thursday)
        var fri = WeekdayTemplate(weekday: .friday)
        var sat = WeekdayTemplate(weekday: .saturday)
        
        for elem in contextAndDailyTime {
        
            let contextBlock = try! ContextBlock.init(context: elem.0, timeBlock: TimeBlock(starts: Time(hour: 0), ends: Time(timeInterval: elem.1)))
            
            do {
                
               try sun.appendContextBlock(contextBlock)
               try mon.appendContextBlock(contextBlock)
               try tue.appendContextBlock(contextBlock)
               try wed.appendContextBlock(contextBlock)
               try thu.appendContextBlock(contextBlock)
               try fri.appendContextBlock(contextBlock)
               try sat.appendContextBlock(contextBlock)
                
            } catch let error as TimeBlockError {
                print(error.description)
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        return WeekTemplate(sun: sun, mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat)
    }
    
}
