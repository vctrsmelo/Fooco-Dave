//
//  MathUtils.swift
//  ProjectManagement
//
//  Created by Rodrigo Cardoso Buske on 09/11/17.
//

import CoreGraphics

extension CGPoint {
	static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}
