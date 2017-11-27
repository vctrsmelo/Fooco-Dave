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
    
    /**
     leftTimeBlocks are the timeblocks still left (without events or activities) in the contextblock.
    */
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
                
                //verifies if can add activity into self
                
                if canAdd(activity: nextActivity) {
                    nextProject.scheduledActivities.append(nextActivity)
                    activities.append(nextActivity)
                    nextActivity.timeBlock.contextBlock = self

                    _leftTimeBlocks = nil
                    _leftTime = nil
                    i = 0
                    continue
                }
            }
            i += 1
        }
        
        setDeadlineOfActivities()
        
    }
    
    /**
     Define the deadline of all activities, considering the events in context block
    */
    func setDeadlineOfActivities() {
        
        //sort activities and define the deadline of an activity act1 as the starting date of the next activity act2.
        //if there is an event after the ending of act1 and before the starting date of act2, the deadline of act1 will be the starting date of this event.
        
        activities.sort()
		
		if !activities.isEmpty {
			for i in 0 ..< activities.count - 1 {
				
				if activities[i] == activities.last {
					
					for event in events {
						//if the event is occupying the ending of this timeBlock
						if event.timeBlock.contains(date: self.timeBlock.endsAt) {
							activities[i].deadline = event.timeBlock.startsAt
							break
						}
					}
					
					activities[i].deadline = self.timeBlock.endsAt
					break
				}
				
				activities[i].deadline = activities[i + 1].timeBlock.startsAt
				
				for event in events {
					//if the event starts before the next activity
					let activityTbUntilDeadline = TimeBlock(startsAt: activities[i].timeBlock.startsAt, endsAt: activities[i].deadline)
					
					if activityTbUntilDeadline.contains(date: event.timeBlock.startsAt) {
						activities[i].deadline = event.timeBlock.startsAt
					}
				}
			}
		}
    }
    
    /**
     Verifies if there is free space to add the activity into context block, considering the respective free time that should exist between two activities.
    */
    func canAdd(activity act: Activity) -> Bool {
        for currentActivity in activities {
            let actSecondsBetAct = act.project.secondsBetweenActivities
            let currActSecondsBetAct = currentActivity.project.secondsBetweenActivities
            let secondsBetweenActivities = (actSecondsBetAct > currActSecondsBetAct) ? actSecondsBetAct : currActSecondsBetAct
        
            //if the time distance between the activity and currentActivity is smaller than the allowed, should not allocate the activity
            if act.timeBlock.startsAt < currentActivity.timeBlock.startsAt && act.timeBlock.endsAt.addingTimeInterval(secondsBetweenActivities) >= currentActivity.timeBlock.startsAt {
                
                //detect if tbl can be resized to support the distance between tbl and activity
                let newEnding = currentActivity.timeBlock.startsAt.addingTimeInterval(-secondsBetweenActivities)
                if newEnding <= act.timeBlock.startsAt {
                    return false
                }
                
            } else if currentActivity.timeBlock.startsAt < act.timeBlock.startsAt && currentActivity.timeBlock.endsAt.addingTimeInterval(secondsBetweenActivities) >= act.timeBlock.startsAt {
                
                //detect if tbl can be resized to support the distance between tbl and activity
                let newStarting = currentActivity.timeBlock.endsAt.addingTimeInterval(secondsBetweenActivities)
                if newStarting >= act.timeBlock.endsAt {
                    return false
                }
                
            }
            
        }
        
        return true
        
    }
    
}

extension ContextBlock: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        return ContextBlock(timeBlock: timeBlock, context: context)
        
    }
    
    
    
}
