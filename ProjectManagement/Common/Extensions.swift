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

extension TimeInterval {
    func inHours() -> Double {
        return self / 1.hour
    }
    
    func inDays() -> Double {
        return self / 1.day
    }
    
    func inMinutes() -> Double {
        return self / 1.minute
    }
}

// MARK: - Core Graphics

extension UIColor {
	static func colorOfAddContext() -> UIColor {
		return #colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1)
	}
}

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

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc
	func dismissKeyboard() {
		view.endEditing(true)
	}
}

extension UINavigationBar {
	func removeBackground() {
		self.setBackgroundImage(UIImage(), for: .default)
		self.shadowImage = UIImage()
	}
	
	func changeFontAndTintColor(to color: UIColor) {
		self.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
		self.tintColor = color
	}
}

extension UIButton {
	func setTitleColor(_ color: UIColor) {
		self.setTitleColor(color, for: .normal)
		self.setTitleColor(color, for: .application)
		self.setTitleColor(color, for: .disabled)
		self.setTitleColor(color, for: .focused)
		self.setTitleColor(color, for: .highlighted)
		self.setTitleColor(color, for: .reserved)
		self.setTitleColor(color, for: .selected)
	}
	
	func setTitle(_ title: String) {
		self.setTitle(title, for: .normal)
		self.setTitle(title, for: .application)
		self.setTitle(title, for: .disabled)
		self.setTitle(title, for: .focused)
		self.setTitle(title, for: .highlighted)
		self.setTitle(title, for: .reserved)
		self.setTitle(title, for: .selected)
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
	
	func toString() -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour, .minute]
		formatter.unitsStyle = .abbreviated
		formatter.maximumUnitCount = 2
		
		return formatter.string(from: self)!
	}
}
