//
//  ContextBlock.swift
//  Fooco
//
//  Created by Victor S Melo on 19/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class ContextBlock {
    
    var timeBlock: TimeBlock
    var context: Context
    
    var activities: [Activity] = []
    var events: [Event]
    
    private var _leftTimeBlocks: [TimeBlock]?
    var leftTimeBlocks: [TimeBlock] {
        
        if _leftTimeBlocks != nil {
            return _leftTimeBlocks!
        }
        
        var timeBlocks = [timeBlock]
        
        //Gera um array de timeblocks, que são os tempos que sobraram após os eventos do usuário serem discontados do timeBlock
        for event in events {
            
            var timeBlocksToAppend: [TimeBlock] = []
            for i in 0 ..< timeBlocks.count {

                let splittedTbs = timeBlocks[i] - event.timeBlock
                timeBlocksToAppend.append(contentsOf: splittedTbs)

            }
            
            timeBlocks = timeBlocksToAppend
        }
        
        for activity in activities {
            var timeBlocksToAppend: [TimeBlock] = []
            for i in 0 ..< timeBlocks.count {
                
                let splittedTbs = timeBlocks[i] - activity.timeBlock
                timeBlocksToAppend.append(contentsOf: splittedTbs)
                
            }
            
            timeBlocks = timeBlocksToAppend
        }
        
        _leftTimeBlocks = timeBlocks
        return _leftTimeBlocks!
    }

    private var _leftTime: Double?
    var leftTime: Double {

        if _leftTime != nil {
            return _leftTime!
        }
        
        var leftTime = timeBlock.totalTime
        
        for event in events {
            leftTime -= event.timeBlock.totalTime
        }
        
        for activity in activities {
            leftTime -= activity.timeBlock.totalTime
        }
        
        _leftTime = leftTime
        return _leftTime!
        
    }
    
    init(timeBlock tbl: TimeBlock, context ctx: Context, activities actvs: [Activity] = [], events evts: [Event] = []) {
        
        timeBlock = tbl
        context = ctx
        activities = actvs
        events = evts
        
    }
    
    func discountEventsTimeIfApplicable(events evts: [Event]) {
        
        if leftTimeBlocks.isEmpty { // testar se cai aqui
            return
        }
        
        for event in evts {
            
            if events.contains(event) {
                continue
            }
            
            let difference = (self.timeBlock - event.timeBlock) //make the difference between both timeBlocks
            
            if difference.count > 1 || difference[0] != self.timeBlock {
                events.append(event)
                _leftTime = nil
                _leftTimeBlocks = nil
            }
            
        }
        
        
        
    }
    
    func addActivities(with evts: [Event]) {
        

        //append events to the contextBlock
        //discountEventsTimeIfApplicable(events: evts) // TODO: activate again
        
        //create the activity
        var i = 0
        while i < leftTimeBlocks.count {
            
            let tbl = leftTimeBlocks[i]
            
            guard let nextProject = User.sharedInstance.getNextProject(for: tbl, and: self.context) else {
                i += 1
                continue
            }
            
            if let nextActivity = nextProject.getNextActivity(for: tbl) {
                activities.append(nextActivity)
                _leftTimeBlocks = nil
                _leftTime = nil
                i = 0
                continue
            }
            i += 1
        }
        
    }
    
}

extension ContextBlock: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        return ContextBlock(timeBlock: timeBlock, context: context)
        
    }
    
    
    
}
