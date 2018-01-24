//
//  User.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 05/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

class User {
    
    // MARK: - Properties
    
    static var sharedInstance = User()
    
    private var _value: [Day] {
        get {
            guard let schedule = _scheduleCache else {
                return []
            }
            
            return schedule
        }
        
        set {
            _scheduleCache = newValue.sorted()
        }
    }
    
    private var _observers: [Observer] = []

    private var _projects: [Project] = []
    private(set) var projects: [Project] {
        set {
            self.schedule = nil
            self._projects = newValue
        }
        get {
            return _projects
        }
    }
    
    var contexts: [Context]
    var weekTemplate: WeekTemplate
    
    /**
        is optional because if schedule changes, must invalidate current schedule cached.
        invariant: must be ordered
    */
    private var _scheduleCache: [Day]?
    
    /**
     User schedule sorted
    */
    private(set) var schedule: [Day]? {
        get {
            return _scheduleCache
        }
        
        set {
            _scheduleCache = newValue?.sorted()
            notifyAllObservers(with: newValue)
        }
    }
    

    /**
     Return all the user's completed activities
    */
    var completedActivities: [(Activity, Date)] {
        var completedActivities: [(Activity, Date)] = []
        for project in projects {
            completedActivities.append(contentsOf: project.completedActivities)
        }
        
        return completedActivities
    }
    
    // MARK: - Init
    
    private init(projects: [Project] = [], contexts: [Context] = [], weekTemplate: WeekTemplate? = nil, schedule: [Day]? = nil) {
        
        if let weekTemp = weekTemplate {
            self.weekTemplate = weekTemp
        } else {
            
            self.weekTemplate = WeekTemplate(sun: WeekdayTemplate(weekday: .sunday), mon: WeekdayTemplate(weekday: .monday), tue: WeekdayTemplate(weekday: .tuesday), wed: WeekdayTemplate(weekday: .wednesday), thu: WeekdayTemplate(weekday: .thursday), fri: WeekdayTemplate(weekday: .friday), sat: WeekdayTemplate(weekday: .saturday))
        }
        
        self.contexts = contexts
        self.projects = projects
        self.schedule = schedule
    }
    
    // MARK: - Methods
    
    /**
     Add the projects into user current projects list
     */
    func add(projects projs: [Project]) {
        projects.append(contentsOf: projs)
    }
    
    /**
     Add the project into user current projects list
     */
    func add(project proj: Project) {
        add(projects: [proj])
    }
    
    func add(contexts ctxs: [Context]) {
        contexts.append(contentsOf: ctxs)
    }
    
    /**
    Remove the projects from user schedule
    */
    func remove(projects projs: [Project]) {
        
        for proj in projs {
            
            if self.projects.contains(proj) {
                self.projects = self.projects.removeElement(proj)
            }
            
        }
        
    }
    
    /**
     Remove all old projects and update them with newProjects parameter
    */
    func updateAllProjects(_ newProjects: [Project]) {
        self.projects = newProjects
    }
    
    /**
     Update the project at the index parameter.
     - Precondition:
        - index: self.projects[index] == Project
    */
    func updateProject(at index: Int, with newProject: Project) {
        
        self.projects[index] = newProject
        
    }
    
    /**
     Remove the project from user schedule
     */
    func remove(project proj: Project) {
        
        remove(projects: [proj])
        
    }
    
    /**
     Invalidates the current schedule cached.
    */
    func invalidateSchedule() {
        self.schedule = nil
    }
    
    /**
     Get next activity available into user schedule.
     - Parameters:
        - untilDate: limit date to search for the next activity. If the activity is beyond that date, will return nil. Default is until tomorrow.
    */
    func getNextActivity(_ untilDate: Date = Date().getDay().addingTimeInterval(1.day)) -> Activity? {
        
        var activity: Activity?
        
        if self.schedule == nil {
            self.updateSchedule(until: untilDate)
        }
        
    
        if let schedule = self.schedule {
  
            var i = 0
            
            while activity == nil && i < schedule.count {
                
                activity = schedule[i].activities.min {
                    $0.timeBlock.start < $1.timeBlock.start
                }
                
                i += 1
                
            }
    
        }
        
        return activity
        
    }
    
    /**
     Skip the next activity time
    */
    func skipNextActivity() {
       
        guard let skippedActivity = self.getNextActivity() else {
            return
        }
        
        let tomorrow = Date().getDay().addingTimeInterval(1.day)
        
        let startingTime = skippedActivity.timeBlock.end
        let startingDate = Date().getDay().addingTimeInterval(startingTime.totalSeconds)

        self.invalidateSchedule()
        self.updateSchedule(until: tomorrow, since: startingDate)
        
    }
    
    /**
     Update the schedule until date parameter. If schedule is not nil, will append next dates.
     - Precondition: schedule should be consistent or nil.
    */
    func updateSchedule(until endingDate: Date, since startingDate: Date = Date()) {
        
        //if schedule exists and is not empty, append next days to it
        if self.schedule != nil && !self.schedule!.isEmpty {
            
            let nextDays = try! AlgorithmManager.getDayScheduleFor(date: endingDate, since: self.schedule!.last!.date)
            self.schedule?.append(contentsOf: nextDays)
            
        //else, if schedule is nil or empty, replace it by a new schedule
        } else {
        
            self.schedule = try! AlgorithmManager.getDayScheduleFor(date: endingDate, since: startingDate)
        
        }
        
    }
    
    
    /**
     Returns the time available for a context until the date parameter, including it. Discount the activities already allocated into schedule.
    */
    func getAvailableTime(for context: Context, until date: Date) -> TimeInterval {

        var returnValue: TimeInterval = 0.0
        //recursive get each day until today (obs: into today, verifies the current time)
        if !date.isToday() {
            
            returnValue += getAvailableTime(for: context, until: date.addingTimeInterval(-1.day))
            
        }
        
        //get date available time for context
        let weekdayTemplate = getWeekdayTemplate(for: date.getWeekday())
        
        //keep contextblocks of context parameter at weekday.
        var weekdayContextBlocks: [ContextBlock] = []
        
        //add contextBlocks lengths if it's for context parameter
        for contextBlock in weekdayTemplate.contextBlocks where contextBlock.context == context {
            returnValue += contextBlock.timeBlock.length
            
            weekdayContextBlocks.append(contextBlock)
        }
        
        //decrease activities length if date is already in schedule
        guard let currentSchedule = schedule else {
            return returnValue
        }
        
        for day in currentSchedule {
            
            //if day is not the weekday being verified, skip it
            if day.date.getWeekday() != weekdayTemplate.weekday {
                continue
            }
            
            for activity in day.activities {

                //if it's an activity for a project
                if let project = activity.project {
                    
                    //verifies if context is the same. If it's, discount the already allocated time from returnValue and continue loop over day.activities
                    if project.context == context {
                        returnValue -= activity.length
                        continue
                    }

                }

                //activity is an event from user calendar. Should discount it's time if it occurs during a context of weekdayContextBlocks
                let calendarEvent = activity
                
                //verifies if calendarEvent occurs during a contextBlock timeBlock for the context parameter.
                for contextBlock in weekdayContextBlocks {
                    
                    //clampedTimeBlock is the timeBlock created from intersection between contextBlock and calendarEvent.timeBlock
                    let clampedTimeBlock = contextBlock.timeBlock.clamp(calendarEvent.timeBlock)
                    
                    //discounts clampedTimeBlock length. If contextBlock does not clamp with calendarEvent, this discount will be of zero, not affecting the algorithm logic.
                    returnValue -= clampedTimeBlock.length
                    
                }
                
                
            }
            
        }
        
        return returnValue
        
    }
    
    /**
     Returns the weekly available time for a context.
    */
    func getWeeklyAvailableTime(for context: Context) -> TimeInterval {
        

        var weekContextBlocks = weekTemplate.value.0.contextBlocks
        weekContextBlocks.append(contentsOf: weekTemplate.value.1.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.2.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.3.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.4.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.5.contextBlocks)
        weekContextBlocks.append(contentsOf: weekTemplate.value.6.contextBlocks)

        var availableTime: TimeInterval = 0.0
        for contextBlock in weekContextBlocks {
            
            if contextBlock.context != context {
                continue
            }

            availableTime += contextBlock.timeBlock.length

        }
        
        return availableTime
        
    }
    
    func getWeekdayTemplate(for weekday: Weekday, startingAt: Time? = nil) -> WeekdayTemplate {

        let initialTime: Time = (startingAt) ?? (try! Time(hour: 0, minute: 0, second: 0))
        
        switch weekday {
        case .sunday:
            return weekTemplate.value.0.startingAt(initialTime)
        case .monday:
            return weekTemplate.value.1.startingAt(initialTime)
        case .tuesday:
            return weekTemplate.value.2.startingAt(initialTime)
        case .wednesday:
            return weekTemplate.value.3.startingAt(initialTime)
        case .thursday:
            return weekTemplate.value.4.startingAt(initialTime)
        case .friday:
            return weekTemplate.value.5.startingAt(initialTime)
        case .saturday:
            return weekTemplate.value.6.startingAt(initialTime)
        }
    }
    
    /**
     Retrieves all completed activities, and the corresponding date they were completed.
     - Parameters:
        - for: filter the activities for the context informed. If nil, returns activities for all contexts.
        - at: filter the activities for the corresponding date. If nil, returns activities for all dates.
     - Returns: All completed activities, and the date they were achieved, filtered according to the parameters.
     */
    func getCompletedActivitiesWithDate(for contextParam: Context? = nil, at dateParam: Date? = nil) -> [(Activity, Date)] {
        
        var completedActivities: [(Activity, Date)] = []
        
        if let context = contextParam {
         
            for project in (projects.filter { $0.context == context }) {
                completedActivities.append(contentsOf: project.completedActivities)
            }
            
        }
        
        if let date = dateParam {
        
            completedActivities = completedActivities.filter { $0.1.getDay() == date.getDay() }
            
        }

        return completedActivities
        
    }
    
    /**
     Retrieves all completed activities
     - Parameters:
        - for: filter the activities for the context informed. If nil, returns activities for all contexts.
        - at: filter the activities for the corresponding date. If nil, returns activities for all dates.
     - Returns: All completed activities filtered according to the parameters.
    */
    func getCompletedActivities(for contextParam: Context? = nil, at dateParam: Date? = nil) -> [Activity] {
        
        let activitiesWithDates = getCompletedActivitiesWithDate(for: contextParam, at: dateParam)
        
        var activities: [Activity] = []
        for activityAndDate in activitiesWithDates {
            
            activities.append(activityAndDate.0)
            
        }
        
        return activities
        
    }
    
    /**
     Retrieves all completed activities, and the corresponding date they were completed.
     - Parameters:
     - for: filter the activities for the project informed. If nil, returns activities for all projects.
     - at: filter the activities for the corresponding date. If nil, returns activities for all dates.
     - Returns: All completed activities, and the date they were achieved, filtered according to the parameters.
     */
    func getCompletedActivitiesWithDate(for projectParam: Project? = nil, at dateParam: Date? = nil) -> [(Activity, Date)] {
        
        var completedActivities: [(Activity, Date)] = []
        
        if let project = projectParam {
            
            completedActivities.append(contentsOf: project.completedActivities)
            
        }
        
        if let date = dateParam {
            
            completedActivities = completedActivities.filter { $0.1.getDay() == date.getDay() }
            
        }
        
        return completedActivities
        
    }
    
    /**
     Retrieves all completed activities
     - Parameters:
     - for: filter the activities for the project informed. If nil, returns activities for all projects.
     - at: filter the activities for the corresponding date. If nil, returns activities for all dates.
     - Returns: All completed activities filtered according to the parameters.
     */
    func getCompletedActivities(for projectParam: Project? = nil, at dateParam: Date? = nil) -> [Activity] {
        
        let activitiesWithDates = getCompletedActivitiesWithDate(for: projectParam, at: dateParam)
        
        var activities: [Activity] = []
        for activityAndDate in activitiesWithDates {
            
            activities.append(activityAndDate.0)
            
        }
        
        return activities
        
    }
    
}

// MARK: - Observable

extension User: Observable {
    
    typealias T = [Day]?
    
    var value: [Day]? {
        get {
            return self.schedule
        }
        set {
            
        }
    }
    
    var observers: [Observer] {
        get {
            return self._observers
        }
        set {
            self._observers = newValue
        }
    }
    
    func addObserver(observer: Observer) {
        self.observers.append(observer)
    }
    
    func removeObserver(observer: Observer) {
        
        observers = observers.filter { $0.observerId != observer.observerId }
        
    }
    
    func notifyAllObservers<T>(with newValue: T) {
        for observer in observers {
            observer.update(with: newValue)
        }
    }
    
} // swiftlint:disable:this file_length
