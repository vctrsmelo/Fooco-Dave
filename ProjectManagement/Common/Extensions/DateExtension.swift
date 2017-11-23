//
//  DateExtension.swift
//  ProjectManagement
//
//  Created by Rodrigo Cardoso Buske on 23/11/17.
//

import Foundation

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
