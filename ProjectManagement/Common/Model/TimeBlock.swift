//
//  TimeBlock.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

enum TimeBlockError: Error {
    case invalidRange
    case overlaps
}

extension TimeBlockError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidRange:
            return "Invalid range in TimeBlock. Probably starting time is after ending."
        case .overlaps:
            return "Two timeblocks are overlapping when they shouldn't."
        }
    }
}

struct TimeBlock {
    private var starts: Time!

    private var ends: Time!
    
    private var range: ClosedRange<Time>! {
        return starts ... ends
    }
    
    init(starts: Time, ends: Time) throws {
        
        try setStarts(starts)
        try setEnds(ends)

    }

    mutating func setStarts(_ starts: Time) throws {

        if ends != nil && starts > ends {
            throw TimeBlockError.invalidRange
        }
        
        self.starts = starts
    }
    
    mutating func setEnds(_ ends: Time) throws {
        if starts != nil && starts > ends {
            throw TimeBlockError.invalidRange
        }
        self.ends = ends
    }

}

extension TimeBlock: IntervalType {
    
    typealias Bound = Time
    
    func getComplement(_ other: TimeBlock) -> [TimeBlock] {
        
        var resultArray: [TimeBlock] = []

        for tbl in self.getSplittedTimeBlocks(with: other) {
            if !other.contains(tbl) {
                resultArray.append(tbl)
            }
        }
        
        return resultArray
    
    }
    
    func contains(_ value: Time) -> Bool {
        return self.range.contains(value)
    }
    
    func contains<I>(_ other: I) -> Bool where I: IntervalType, TimeBlock.Bound == I.Bound {
        return self.range.contains(other.start) && self.range.contains(other.end)
    }
    
    func overlaps<I>(_ other: I) -> Bool where I: IntervalType, Time == I.Bound {
        return ((self.start <= other.start && self.end >= other.start) || (other.start <= self.start && other.end >= self.starts))
    }
    
    var end: Time {
        return self.ends
    }
    
    var isEmpty: Bool {
        return ends - starts > 0
    }
    
    var start: Time {
        return self.starts
    }
    
    func clamp(_ intervalToClamp: TimeBlock) -> TimeBlock {
        let newInterval = intervalToClamp.range.clamped(to: self.range)
        return try! TimeBlock(starts: newInterval.lowerBound, ends: newInterval.upperBound)
    }

}

extension TimeBlock: TimeIntervalType {

    var length: TimeInterval {
        return self.ends - self.starts
    }
    
}

extension TimeBlock: Equatable {
    
    static func == (_ tb1: TimeBlock, _ tb2: TimeBlock) -> Bool {
        return tb1.range == tb2.range
    }

    static func != (_ tb1: TimeBlock, _ tb2: TimeBlock) -> Bool {
        return tb1.range != tb2.range
    }
    
}

extension TimeBlock: Hashable {
    var hashValue: Int {
        return self.starts.hashValue &+ self.ends.hashValue // &+ is the operator for addition that allows overflow
    }
}

extension TimeBlock {
    
    /**
     Return an array of timeBlocks resulted from the split of self with other timeblock
    */
    private func getSplittedTimeBlocks(with other: TimeBlock) -> [TimeBlock] {
        
        if !self.overlaps(other) {
            return [self, other]
        }
        
//        var times: [Time] = getTimesWithoutDuplicatedValues(from: [self.start, self.end, other.start, other.end])
  
        var times: [Time] = [self.start, self.end, other.start, other.end].removeDuplicates()
        
        times.sort()
        
        var resultTimeBlocks: [TimeBlock] = []

        if !times.isEmpty {
            for i in 0 ..< times.count - 1 {
                
                resultTimeBlocks.append(try! TimeBlock(starts: times[i], ends: times[i + 1]))
            }
        }
        
        return resultTimeBlocks
        
    }
}
