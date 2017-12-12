//
//  TimeBlock.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//


import Foundation

enum TimeBlockError: Error {
    case invalidRange(String)
}


struct TimeBlock {

    private var starts: Time!
    private var ends: Time!
    
    private var range: ClosedRange<Time>!{
        return starts ... ends
    }
    
    init(starts: Time, ends: Time) throws{
        
        try setStarts(starts)
        try setEnds(ends)

    }

    mutating func setStarts(_ starts: Time) throws {
        
        if ends != nil && starts > ends {
            throw TimeBlockError.invalidRange("[setEnds error]: Starts is after ends: new start value is \(starts) while ends value is \(self.ends)")
        }
        
        self.starts = starts
    }
    
    mutating func setEnds(_ ends: Time) throws {
        if starts != nil && starts > ends {
            throw TimeBlockError.invalidRange("[setEnds error]: Starts is after ends: new start value is \(starts) while ends value is \(self.ends)")
        }
        self.ends = ends
    }

}

extension TimeBlock: IntervalType {
    
    typealias Bound = Time
    
    func contains(_ value: Time) -> Bool {
        return self.range.contains(value)
    }
    
    func overlaps<I>(_ other: I) -> Bool where I : IntervalType, Time == I.Bound {
        return ((self.start <= other.start && self.end >= other.start) || (other.start <= self.start && other.end >= self.end))
    }
    
    var end: Time {
        return self.end
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

extension TimeBlock: Equatable {
    
    static func ==(_ tb1: TimeBlock, _ tb2: TimeBlock) -> Bool{
        return tb1.range == tb2.range
    }

    static func !=(_ tb1: TimeBlock, _ tb2: TimeBlock) -> Bool{
        return tb1.range != tb2.range
    }
    
}

