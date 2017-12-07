//
//  EditContextViewModel.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import CoreGraphics
import Foundation

enum DayInWeek: Int {
	case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

class EditContextViewModel {
	
	let context: Context
	
	private let barSize: CGFloat = 100
	
	private var week = [DayInWeek: [TimeBlock]]()
	
	private var busiestDayTotalTime: TimeInterval {
		var maxValue: TimeInterval = 1
		
		for day in self.week {
			let currentValue = self.time(for: day.key)
			
			if currentValue > maxValue {
				maxValue = currentValue
			}
		}
		
		return maxValue
	}
	
	private var totalWeeklyTime: TimeInterval = 0
	
	var totalWeeklyTimeDescription: String {
		return self.timeFormater(self.totalWeeklyTime)
	}
	
	init(context: Context) {
		self.context = context
	}
	
	private func time(for day: DayInWeek) -> TimeInterval {
		var totalTime: TimeInterval = 0
		
		if let someDay = self.week[day] {
			for someTime in someDay {
				totalTime += someTime.totalTime
			}
		}
		
		return totalTime
	}
	
	func timeDescription(for day: DayInWeek) -> String {
		return self.timeFormater(self.time(for: day))
	}
	
	func size(for day: DayInWeek) -> CGFloat {
		let dayTime = self.time(for: day)
		
		var size = CGFloat(dayTime / self.busiestDayTotalTime)
		
		if size == 0 {
			size = 0.1
		}
		
		return size * self.barSize
	}
	
	func timeFormater(_ time: TimeInterval) -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute]
		formatter.unitsStyle = .abbreviated
		
		return formatter.string(from: time)!
	}
}
