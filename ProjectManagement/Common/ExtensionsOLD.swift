//
//  Extensions.swift
//  ProjectManagement
//
//  Created by Rodrigo Cardoso Buske on 23/11/17.
//

import UIKit

// MARK: - Foundation

extension Array {
	func random(from: Int? = nil, to: Int? = nil) -> Element {
		
		let begin = ((from == nil || from! > to!) ? 0 : from)!              // if "from" is nil, begin = 0
		let end = ((to == nil || to! > (self.count)) ? self.count : to)!    // if "to" is nil, end = self.count
		
		let i = end - begin   // difference between end and begin
		
		var randomIndex = Int(arc4random_uniform(UInt32(i)))
		randomIndex += begin    // move "begin" values to the right
		
		return self[randomIndex]
		
	}
	
}

//extension Int {
//    var timeInterval: TimeInterval {
//        return TimeInterval(self)
//    }
//
//    var seconds: TimeInterval {
//        return self.timeInterval
//    }
//    var second: TimeInterval {
//        return self.seconds
//    }
//
//    var minutes: TimeInterval {
//        return self.timeInterval * 60.seconds
//    }
//    var minute: TimeInterval {
//        return self.minutes
//    }
//
//    var hours: TimeInterval {
//        return self.timeInterval * 60.minutes
//    }
//    var hour: TimeInterval {
//        return self.hours
//    }
//
//    var days: TimeInterval {
//        return self.timeInterval * 24.hours
//    }
//    var day: TimeInterval {
//        return self.days
//    }
//}

// MARK: - Core Graphics

extension UIColor {
	
	static func interfaceColors() -> [UIColor] {
		return [#colorLiteral(red: 0.2171623707, green: 0.4459149837, blue: 0.5379145741, alpha: 1), #colorLiteral(red: 0.3586075306, green: 0.7084770203, blue: 0.610791266, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.6141311526, green: 0.8158430457, blue: 0.5836192369, alpha: 1), #colorLiteral(red: 0.0337530449, green: 0.1313122213, blue: 0.2268140912, alpha: 1)]
	}
	
	static func contextColors() -> [UIColor] {
		return [#colorLiteral(red: 0.002415449687, green: 0.5572095285, blue: 0.6159396701, alpha: 1), #colorLiteral(red: 0.5, green: 0, blue: 0.2020547865, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]
	}
	
	static func colorOfAddContext() -> UIColor {
		return #colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1)
	}
}

extension UIImage {
	convenience init?(from color: UIColor) {
		let rect = CGRect(origin: .zero, size: CGSize.one)
		
		UIGraphicsBeginImageContext(rect.size)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}
}

extension CGPoint {
	static var one: CGPoint {
		return CGPoint(x: 1, y: 1)
	}
	
	static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}

extension CGSize {
	static var one: CGSize {
		return CGSize(width: 1, height: 1)
	}
}

// MARK: - UIKit

extension UIView {
	// MARK: Shadows
	@IBInspectable var shadowColor: UIColor? {
		get {
			if let currentShadowColor = self.layer.shadowColor {
				return UIColor(cgColor: currentShadowColor)
			} else {
				return nil
			}
		}
		set {
			if let newColor = newValue {
				self.layer.shadowColor = newColor.cgColor
			} else {
				self.layer.shadowColor = nil
			}
		}
	}
	
	@IBInspectable var shadowOffset: CGSize {
		get {
			return self.layer.shadowOffset
		}
		set {
			self.layer.shadowOffset = newValue
		}
	}
	
	@IBInspectable var shadowRadius: CGFloat {
		get {
			return self.layer.shadowRadius
		}
		set {
			self.layer.shadowRadius = newValue
		}
	}
	
	@IBInspectable var shadowOpacity: Float {
		get {
			return self.layer.shadowOpacity
		}
		set {
			self.layer.shadowOpacity = newValue
		}
	}
	
	// MARK: Corners
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
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc
	func dismissKeyboard() {
		view.endEditing(true)
	}
}

extension UINavigationBar {
	func removeBackgroundImage() {
		self.setBackgroundImage(UIImage(from: .clear), for: .default)
	}
	
	func removeShadowAndBackgroundImage() {
		self.removeBackgroundImage() // The background image cannot be the default for the shadow to be removed
		
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

//extension Date {
//    
//    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
//        let dateFormatter = DateFormatter()
//        
//        dateFormatter.dateStyle = dateStyle
//        dateFormatter.timeStyle = timeStyle
//        
//        return dateFormatter.string(from: self)
//    }
//    
//    /**
//    Set hours, minutes and seconds to zero, returning only the day.
//    */
//    func getDay() -> Date {
//        
//        let today = Calendar.current.dateComponents([.day, .month, .year], from: self)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        
//        return dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!)")!
//        
//    }
//}

//extension TimeInterval {
//    var inHours: Double {
//        return self / 1.hour
//    }
//
//    var inDays: Double {
//        return self / 1.day
//    }
//
//    var inMinutes: Double {
//        return self / 1.minute
//    }
//
//    func toString() -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.day, .hour, .minute]
//        formatter.unitsStyle = .abbreviated
//        formatter.maximumUnitCount = 2
//
//        return formatter.string(from: self)!
//    }
//}

