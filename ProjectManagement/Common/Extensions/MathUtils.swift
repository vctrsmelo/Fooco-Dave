//
//  MathUtils.swift
//  ProjectManagement
//
//  Created by Rodrigo Cardoso Buske on 09/11/17.
//

import CoreGraphics
import Foundation

extension CGPoint {
	static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}

extension TimeInterval {
	func toString() -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour, .minute]
		formatter.unitsStyle = .abbreviated
		formatter.maximumUnitCount = 2
		
		return formatter.string(from: self)!
	}
}
