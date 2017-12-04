//
//  EditContextViewModel.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import UIKit

enum DayInWeek: Int {
	case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

class EditContextViewModel {
	
	let contextName: String
	let color: UIColor
	
	private var totalWeeklyTime: TimeInterval = 0
	
	var totalWeeklyTimeDescription: String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute]
		formatter.unitsStyle = .abbreviated
		
		return formatter.string(from: self.totalWeeklyTime)!
	}
	
	init(name: String, color: UIColor) {
		self.contextName = name
		self.color = color
	}
	
	func time(for day: DayInWeek) -> String {
		return "0h"
	}
	
	func size(for day: DayInWeek) -> CGFloat {
		return 0
	}
	
}
