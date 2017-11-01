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
    var events: [TimeBlock]
    
    private var _leftTimeBlocks: [TimeBlock]? = nil
    var leftTimeBlocks: [TimeBlock] {
        get {
            if _leftTimeBlocks != nil {
                return _leftTimeBlocks!
            }
            var timeBlocks = [timeBlock]
            
            //Gera um array de timeblocks, que são os tempos que sobraram após os eventos do usuário serem discontados do timeBlock
            for event in events {
                for i in 0 ..< timeBlocks.count-1 {

                    let splittedTbs = timeBlocks[i] - event
                    timeBlocks.remove(at: i)
                    timeBlocks.append(contentsOf: splittedTbs)

                }
            }
            _leftTimeBlocks = timeBlocks
            return _leftTimeBlocks!
        }
    }
    
    private var _leftTime: Double? = nil
    var leftTime: Double{
        get {
            
            if _leftTime != nil{
                return _leftTime!
            }
            
            var leftTime = timeBlock.totalTime
            
            for event in events {
                leftTime -= event.totalTime
            }
            
            _leftTime = leftTime
            return _leftTime!
            
        }
        
    }
    
    init(timeBlock tb: TimeBlock, context ctx: Context, activities actvs: [Activity] = [], events evts: [TimeBlock] = []) {
        
        timeBlock = tb
        context = ctx
        activities = actvs
        events = evts
        
    }
    
    func discountEventsTimeIfApplicable(events evts: [TimeBlock]) {
        
        for event in evts {
            
            if events.contains(event) {
                continue
            }
            
            let difference = (self.timeBlock - event) //make the difference between both timeBlocks
            
            if difference.count > 1 || difference[0] != self.timeBlock {
                events.append(event)
                _leftTime = nil
                _leftTimeBlocks = nil
            }
            
        }
        
    }
    
}

extension ContextBlock: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        return ContextBlock(timeBlock: timeBlock, context: context)
        
    }
    
    
    
}
