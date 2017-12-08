//
//  Timeblock.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

struct TimeBlock {

    var startsAt: Date
    var endsAt: Date
    var contextBlock: ContextBlock?
    
    var totalTime: TimeInterval {
        get {
            return endsAt.timeIntervalSince(startsAt)
        }
    }
    
    init(startsAt starting: Date, endsAt ending: Date) {
        
        if Calendar.current.compare(starting, to: ending, toGranularity: .hour) == ComparisonResult.orderedDescending {
            fatalError("[Timeblock init] tried to create a timeblock with starting date after ending date. Starting date is \(starting) and ending date is \(ending)")
            
        }

        startsAt = starting
        endsAt = ending
        
    }
    
    /**
     Split two timeblocks according to their intersections. If are not intersecting or are the same, return nil.
     */
    static func split(timeBlock1 tb1: TimeBlock, timeBlock2 tb2: TimeBlock) -> [TimeBlock]? {

//        let tb1StartsDay = Calendar.current.component(.day, from: tb1.startsAt)
//        let tb1EndsDay = Calendar.current.component(.day, from: tb1.endsAt)
//
//        let tb2StartsDay = Calendar.current.component(.day, from: tb2.startsAt)
//        let tb2EndsDay = Calendar.current.component(.day, from: tb2.endsAt)

        //if are not intersecting or are the same, return []
        if tb1.endsAt <= tb2.startsAt ||
            tb1.startsAt >= tb2.endsAt ||
            (tb1.startsAt == tb2.startsAt && tb1.endsAt == tb2.endsAt) {
            return nil
        }

        var dates = [tb1.startsAt,tb1.endsAt,tb2.startsAt,tb2.endsAt]

        dates.sort()

        var datesToRemove: [Int] = []

        //remove duplicated dates
        for i in 0 ..< dates.count-1 {
            
            if dates[i] == dates[i+1] {
                datesToRemove.append(i)
            }

        }

        while !datesToRemove.isEmpty {
            dates.remove(at: datesToRemove.popLast()!)
        }

        return getTimeBlocksFrom(datesArray: dates)

    }

    /**
     Get timeblocks from the space between the dates in array.
     */
    static func getTimeBlocksFrom(datesArray dates: [Date]) -> [TimeBlock] {

        var timeBlocks: [TimeBlock] = []

        for i in 0 ..< dates.count-1 {
            timeBlocks.append(TimeBlock(startsAt: dates[i], endsAt: dates[i+1]))
        }

        return timeBlocks
    }

    func contains(timeBlock tbl: TimeBlock) -> Bool {
        return (self.startsAt <= tbl.startsAt && self.endsAt >= tbl.endsAt)
    }
    
    func contains(date dte: Date) -> Bool {
        
        return (self.startsAt <= dte && self.endsAt >= dte)
    
    }
    
}

extension TimeBlock {

    /**
     If the contained timeblock is inside the container, return the timeBlocks resulting from removing the contained timeBlock from container.
     */
    static func -(container: TimeBlock, contained: TimeBlock) -> [TimeBlock] {

        if container == contained {
            return []
        }
        
        if contained.endsAt <= container.startsAt ||
           contained.startsAt >= container.endsAt {
            return [container]
        }
        
        guard var splittedTimeBlocks = self.split(timeBlock1: container, timeBlock2: contained) else { return [container]}

        var indexToRemove: [Int] = []
        for i in 0 ..< splittedTimeBlocks.count {

            if contained.contains(timeBlock: splittedTimeBlocks[i]){

                indexToRemove.append(i)

            }

        }

        while !indexToRemove.isEmpty {

            splittedTimeBlocks.remove(at: indexToRemove.popLast()!)

        }

        return splittedTimeBlocks

    }


}

extension TimeBlock: Equatable, Comparable, Hashable {
	var hashValue: Int {
		return self.startsAt.hashValue &+ self.endsAt.hashValue // TODO: This should not be in the final version
	}
	
    static func < (lhs: TimeBlock, rhs: TimeBlock) -> Bool {
        return (lhs.startsAt < rhs.startsAt)
    }
    
    
    static func == (lhs: TimeBlock, rhs: TimeBlock) -> Bool {
        
        let beginHourLhs = Calendar.current.component(.hour, from: lhs.startsAt)
        let beginHourRhs = Calendar.current.component(.hour, from: rhs.startsAt)
        
        let endsHourLhs = Calendar.current.component(.hour, from: lhs.endsAt)
        let endsHourRhs = Calendar.current.component(.hour, from: rhs.endsAt)
        
        return (beginHourLhs == beginHourRhs && endsHourLhs == endsHourRhs)
        
    }

    
}
