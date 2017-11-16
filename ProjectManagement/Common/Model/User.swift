//
//  User.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class User: NSObject {
    
    static let sharedInstance = User()
    
    var projects: [Project]
    var contexts: [Context]
    var weekSchedule: Week
    //var safetyMargin = 0.2 //20%
    
    private var currentSchedule: [Date: Weekday] = [:]
    
    private var _isCurrentScheduleUpdated: Bool = false
    var isCurrentScheduleUpdated: Bool {
        get {
            return _isCurrentScheduleUpdated
        }
        set {
            
            if newValue == false {
                for proj in projects {
                    proj.userScheduleInvalidated()
                }
            }
            
            _isCurrentScheduleUpdated = newValue
            
        }
        
    }
    
    private init(projects projs: [Project] = [], contexts ctxs: [Context] = [], week: Week = Week()) {
        projects = projs
        contexts = [Mocado.context1] //TODO: editar
        weekSchedule = week
		
        projects.sort()
        
    }

    
    func getSchedule(for date: Date) -> Weekday? {
        
        return currentSchedule[date.getDay()]
        
    }
    
    /**
     Append the projects into user current projects list
    */
    func add(projects projs: [Project]) {
        projects.append(contentsOf: projs)
        projects.sort()
        
    }
    
    func add(contexts ctxs: [Context]) {
        contexts.append(contentsOf: ctxs)
    }
    
    func set(weekSchedule week: Week) {
        weekSchedule = week
    }
    
    /**
     return the user events of date as TimeBlock
     */
    func getEvents(at date: Date) -> [Event] {
        
        return [] //TODO: implement this method
    }
    
    func updateCurrentScheduleUntil(date: Date) {
        
        isCurrentScheduleUpdated = false
        self.updateCurrentScheduleUntilAux(date: date)
        isCurrentScheduleUpdated = true
        
    }
    
    private func updateCurrentScheduleUntilAux(date: Date) {
    
        //recursivity
        if date.getDay() > Date().getDay() {
            
            updateCurrentScheduleUntilAux(date: Calendar.current.date(byAdding: .day, value: -1, to: date.getDay())!)
        }
        
        //get weekday
        guard let weekday = self.weekSchedule.getDay(for: date) else {
            return
        }
        
        let events = self.getEvents(at: date)
        
        loopContextBlocks: for contextBlock in weekday.contextBlocks {
            contextBlock.addActivities(with: events)
        }
        
        set(weekday: weekday, for: date)
        
    }
    
    private func set(weekday: Weekday, for date: Date) {
        currentSchedule[date.getDay()] = weekday
    }
    
    func getNextProject(for timeBlock: TimeBlock, and context: Context) -> Project? {
    
        for i in 0 ..< projects.count {
            if projects[i].context == context && projects[i].timeLeftEstimated > 0 {
                if projects[i].canAllocateActivity(for: timeBlock) {
                    return projects[i]
                }
            }
        }
        
        return nil
        
    }

}

extension Date {
    
    /**
     Set hours, minutes and seconds to zero, returning only the day.
    */
    func getDay() -> Date {
        
        let today = Calendar.current.dateComponents([.day,.month,.year], from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        return dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!) 00:00:00")!
        
    }
}
