//
//  WeekdayTemplate.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

/**
 weekdays, where sunday is 1 and saturday is 7
 */
enum Weekday: Int {
	
	case sunday = 1
	case monday
	case tuesday
	case wednesday
	case thursday
	case friday
	case saturday
	
	enum SizeStyle {
		case veryShort, short, normal
	}
	
	func string(_ style: SizeStyle) -> String {
		switch style {
		case .veryShort:
			return Calendar.current.veryShortStandaloneWeekdaySymbols[self.rawValue - 1]
			
		case .short:
			return Calendar.current.shortStandaloneWeekdaySymbols[self.rawValue - 1]
			
		case .normal:
			return Calendar.current.standaloneWeekdaySymbols[self.rawValue - 1]
		}
	}
	
	static func weekdaysText(for days: [Weekday], style: SizeStyle, friendlyDates: Bool) -> String {
		
		if friendlyDates && days == [.monday, .tuesday, .wednesday, .thursday, .friday] {
			return NSLocalizedString("at business days", comment: "Text for all business days selected")
			
		} else if friendlyDates && days == [.sunday, .saturday] {
			return NSLocalizedString("at weekends", comment: "Text for weekend selected")
			
		} else if friendlyDates && days == [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday] {
			return NSLocalizedString("every day", comment: "Text for every day selected")
			
		} else {
			var weekdaysText = ""
			
			for day in days {
				if day == days.first {
					weekdaysText.append(NSLocalizedString("at ", comment: "weekdaysText first part"))
				} else if day == days.last {
					weekdaysText.append(NSLocalizedString(" and ", comment: "weekdaysText second to last part"))
				} else {
					weekdaysText.append(", ")
				}
				
				weekdaysText.append(day.string(style).lowercased())
			}
			
			return weekdaysText
		}
	}
}

extension Weekday: Comparable {
	static func < (lhs: Weekday, rhs: Weekday) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}

/**
 The template for user's weekday. It includes the respective weekday and the contextblocks of these weekdays.
 */
struct WeekdayTemplate {
    
    var weekday: Weekday
    private(set) var contextBlocks: [ContextBlock] = []

    init(weekday: Weekday, contextBlocks: [(TimeBlock, Context)] = []) {

        self.weekday = weekday
        
        for tuple in contextBlocks {
            self.contextBlocks.append(ContextBlock(tuple))
        }
        
    }
    
    init(weekday: Weekday, contextBlocks: [ContextBlock]) {
        
        self.weekday = weekday
        self.contextBlocks = contextBlocks
        
    }
    
    mutating func appendContextBlock(_ contextBlock: ContextBlock) throws {
        for cb in contextBlocks {
            if cb.timeBlock.overlaps(contextBlock.timeBlock) {
                throw TimeBlockError.overlaps
            }
        }
        
        contextBlocks.append(contextBlock)
    }
    
    /**
     Returns the weekdayTemplate starting at the specified time parameter. Useful for when user skips an activity.
    */
    func startingAt(_ time: Time) -> WeekdayTemplate {
        
        var newContextBlocks: [ContextBlock] = []
        
        for contextBlock in self.contextBlocks {
    
            //if the contextblock contains the lower bound time, it should be splitted, using time as starting time
            if contextBlock.timeBlock.contains(time) {
                
                let newTimeBlock = try! TimeBlock(starts: time, ends: contextBlock.timeBlock.end)
                newContextBlocks.append(ContextBlock(context: contextBlock.context, timeBlock: newTimeBlock))
             
                continue
                
            }
            
            newContextBlocks.append(contextBlock)
            
        }
        
        return WeekdayTemplate(weekday: self.weekday, contextBlocks: newContextBlocks)
        
    }
    
}

extension WeekdayTemplate: Equatable {
    static func == (lhs: WeekdayTemplate, rhs: WeekdayTemplate) -> Bool {
        
        if lhs.weekday != rhs.weekday {
            return false
        }

        for lhsCb in lhs.contextBlocks {
            
            if !rhs.contextBlocks.contains(lhsCb) {
                return false
            }
        }
        
        return true
    }
}
