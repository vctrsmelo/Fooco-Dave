//
//  CustomProtocols.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 29/11/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

/**
 An interval over a Comparable type.
 */
protocol IntervalType {
    
    associatedtype Bound: Comparable
    
    /**
     invariant: start <= end
     */
    var end: Self.Bound{
        get
    }
    
    /**
     true iff self is empty
     */
    var isEmpty: Bool {
        get
    }
    
    /**
     invariant: start <= end
     */
    var start: Self.Bound {
        get
    }
    
    /**
     Return rhs clamped to self. The bounds of the result, even if it is empty, are always within the bounds of self.
    */
    func clamp(_ intervalToClamp: Self) -> Self
    
    /**
     Returns true iff the interval contains value.
    */
    func contains(_ value: Self.Bound) -> Bool

    /**
     Returns true if lhs contains rhs.
     */
    func contains<I : IntervalType>(_ other: I) -> Bool where I.Bound == Bound
    
    /**
    Returns true if lhs and rhs have a non-empty intersection.
    */
    func overlaps<I : IntervalType>(_ other: I) -> Bool where I.Bound == Bound
    
    /**
     Get intervals from self that are not contained into parameter. It is the complement of the parameter.
     */
    func getComplement(_ other: Self) -> [Self]
    
}
