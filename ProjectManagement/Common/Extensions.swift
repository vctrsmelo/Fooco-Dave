//
//  Extensions.swift
//  ProjectManagement
//
//  Created by Rodrigo Cardoso Buske on 23/11/17.
//

import UIKit

// MARK: - Math

extension Int {
	var timeInterval: TimeInterval {
		return TimeInterval(self)
	}
	
	var seconds: TimeInterval {
		return self.timeInterval
	}
	var second: TimeInterval {
		return self.seconds
	}
	
	var minutes: TimeInterval {
		return self.timeInterval * 60.seconds
	}
	var minute: TimeInterval {
		return self.minutes
	}
	
	var hours: TimeInterval {
		return self.timeInterval * 60.minutes
	}
	var hour: TimeInterval {
		return self.hours
	}
	
	var days: TimeInterval {
		return self.timeInterval * 24.hours
	}
	var day: TimeInterval {
		return self.days
	}
}

// MARK: - Core Graphics

extension CGPoint {
	static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}

// MARK: - UIKit

extension UIView {
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
		}
	}
	
}

extension UINavigationBar {
	func removeBackground() {
		self.setBackgroundImage(UIImage(), for: .default)
		self.shadowImage = UIImage()
		self.isTranslucent = true
	}
}

// MARK: Date

extension Date {
	
	func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateStyle = dateStyle
		dateFormatter.timeStyle = timeStyle
		
		return dateFormatter.string(from: self)
	}
	
	/**
	Set hours, minutes and seconds to zero, returning only the day.
	*/
	func getDay() -> Date {
		
		let today = Calendar.current.dateComponents([.day, .month, .year], from: self)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy"
		
		return dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!)")!
		
	}
}

extension TimeInterval {
	
//	fileprivate static let second: TimeInterval = 1
//	fileprivate static let minute: TimeInterval = 60 * second
//	fileprivate static let hour: TimeInterval = 60 * minute
//	fileprivate static let day: TimeInterval = 24 * hour
	
	func toString() -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour, .minute]
		formatter.unitsStyle = .abbreviated
		formatter.maximumUnitCount = 2
		
		return formatter.string(from: self)!
	}
}
