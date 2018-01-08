//
//  Extensions.swift
//  ProjectManagement
//
//  Created by Rodrigo Cardoso Buske on 23/11/17.
//

import UIKit

// MARK: - Foundation

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
    
    /**
     Return the value in hours unit
     */
    var inHours: Double {
        return self / 1.hour
    }
    
    /**
     Return the value in days unit
     */
    var inDays: Double {
        return self / 1.day
    }
    
    /**
     Return the value in minutes unit
     */
    var inMinutes: Double {
        return self / 1.minute
    }
}

extension Date {
    
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter.string(from: self)
    }
    
    /**
     Verifies if self is today
     */
    func isToday() -> Bool {
        return self.getDay() == Date().getDay()
    }
    
    /**
     Return the same date with hours, minutes and seconds setted to zero.
     */
    func getDay() -> Date {
        
        let today = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.date(from: "\(today.day!)-\(today.month!)-\(today.year!)")!
        
    }
    
    /**
     Returns the Weekday.
     - precondition: Calendar must be gregorian, where weekday starts as 1 (sunday) and ends as 7 (saturday).
     */
    func getWeekday() -> Weekday {
        return Weekday(rawValue: Calendar.current.component(.weekday, from: self))!
    }
    
}

extension Array {
    func random(from initial: Int? = nil, to final: Int? = nil) -> Element {
        
        let begin = ((initial == nil || initial! > final!) ? 0 : initial)!              // if "initial" is nil, begin = 0
        let end = ((final == nil || final! > (self.count)) ? self.count : final)!    // if "final" is nil, end = self.count
        
        let i = end - begin   // difference between end and begin
        
        var randomIndex = Int(arc4random_uniform(UInt32(i)))
        randomIndex += begin    // move "begin" values to the right
        
        return self[randomIndex]
        
    }
    
}

extension Array where Element: Project {
    
    /**
     Returns an array of tuples of a project and it's priority value.
     It's useful to keep the priority value in "cache", as it's calculation is not trivial.
     */
    func withPriorityValue(sorted: Bool = false) -> [(Project,Priority)] {
        var returnArray: [(Project,Priority)] = []
        
        for proj in self {
            returnArray.append((proj,proj.priority))
        }
        
        if sorted {
            //sort by priority values.
            returnArray.sort { (arg0, arg1) -> Bool in
                let priority1 = arg0.1
                let priority2 = arg1.1
                return (priority1 > priority2)
            }
        }
        
        return returnArray
    }
    
    
}

extension Array where Element: Equatable {
    
    /**
     Remove duplicated values
     */
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    
}

extension Array where Element: Day {
    
    /**
     Return only the activities of the array of days.
     */
    var activities: [Activity] {
        var activities: [Activity] = []
        for day in self {
            activities.append(contentsOf: day.activities)
        }
        return activities
    }
    
}

extension Dictionary {
    func row(_ counter: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: counter)]
    }
}

// MARK: - Core Graphics

extension UIColor {
    
    struct Interface {
        private init() {}
        
        static let iWhite = #colorLiteral(red: 0.9677794576, green: 1, blue: 0.963481009, alpha: 1)
        static let iLightGreen = #colorLiteral(red: 0.7637994885, green: 0.948982656, blue: 0.7377385497, alpha: 1)
        static let iGreen = #colorLiteral(red: 0.3586075306, green: 0.7084770203, blue: 0.610791266, alpha: 1)
        static let iBlue = #colorLiteral(red: 0.3035645783, green: 0.547811389, blue: 0.648229301, alpha: 1)
        static let iDarkBlue = #colorLiteral(red: 0.1394162476, green: 0.3316068649, blue: 0.4398950338, alpha: 1)
        static let iPurple = #colorLiteral(red: 0.2533134818, green: 0.2501349747, blue: 0.5410738587, alpha: 1)
        static let iBlack = #colorLiteral(red: 0.0337530449, green: 0.1313122213, blue: 0.2268140912, alpha: 1)
    }
    
    static let addContextColor = #colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1)
    
    static func contextColors() -> [UIColor] {
        return [#colorLiteral(red: 0.596470058, green: 0.8240941167, blue: 0.8377798796, alpha: 1), #colorLiteral(red: 0.2224018574, green: 0.7209109664, blue: 0.59053123, alpha: 1), #colorLiteral(red: 0.8436028361, green: 0.6334985495, blue: 0.6773697734, alpha: 1), #colorLiteral(red: 0.7921995521, green: 0.8247993588, blue: 0.4140916467, alpha: 1), #colorLiteral(red: 0.9068188071, green: 0.3804750741, blue: 0.3638587296, alpha: 1), #colorLiteral(red: 0.5450553298, green: 0.679359138, blue: 0.6552342772, alpha: 1), #colorLiteral(red: 0.4687731862, green: 0.4971648455, blue: 0.7168904543, alpha: 1)]
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
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
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
    func hideKeyboardOnOutsideTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
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
