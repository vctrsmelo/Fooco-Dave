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


class TimeBlock {

    private(set) var starts: Time
    private(set) var ends: Time
    
    private var range: ClosedRange<Time>!{
        return starts ... ends
    }
    
    init(starts: Time, ends: Time) throws{
        
        if starts > ends {
            throw TimeBlockError.invalidRange("[setEnds error]: Starts is after ends: new start value is \(starts) while ends value is \(ends)")
        }
        
        self.starts = starts
        self.ends = ends
    }

    func setStarts(_ starts: Time) throws {
        
        if starts > ends {
            throw TimeBlockError.invalidRange("[setEnds error]: Starts is after ends: new start value is \(starts) while ends value is \(self.ends)")
        }
        
        self.starts = starts
    }
    
    func setEnds(_ ends: Time) throws {
        if starts > ends {
            throw TimeBlockError.invalidRange("[setEnds error]: Starts is after ends: new start value is \(starts) while ends value is \(self.ends)")
        }
        self.ends = ends
    }

}

extension TimeBlock {
    
    func contains(_ bound: Time) -> Bool {
        return self.range.contains(bound)
    }
    
    func overlaps(_ other:  Range<Time>) -> Bool {
        return self.range.overlaps(other)
    }
    
    static func ==(_ tb1: TimeBlock, _ tb2: TimeBlock) -> Bool{
        return tb1.range == tb2.range
    }

    static func !=(_ tb1: TimeBlock, _ tb2: TimeBlock) -> Bool{
        return tb1.range != tb2.range
    }
    
}

