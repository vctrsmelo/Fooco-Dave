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
	
	private var totalWeeklyTime: TimeInterval {
		var value: TimeInterval = 0
		
		value = self.week.reduce(0) { partialResult, day -> TimeInterval in
			return partialResult + self.time(for: day.key)
		}
		
		return value
	}
	
	var totalWeeklyTimeDescription: String {
		return self.timeFormater(self.totalWeeklyTime)
	}
	
	init(context: Context) {
		self.context = context
		
		self.loadData()
	}
	
	private func loadData() {
		let now = Date()
		self.createTimeBlock(start: now, end: now.addingTimeInterval(3.hours), for: .monday)
		self.createTimeBlock(start: now, end: now.addingTimeInterval(3.hours), for: .tuesday)
		self.createTimeBlock(start: now.addingTimeInterval(4.hours), end: now.addingTimeInterval(6.hours), for: .tuesday)
		self.createTimeBlock(start: now, end: now.addingTimeInterval(6.hours), for: .wednesday)
	}
	
	private func timeFormater(_ time: TimeInterval) -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute]
		formatter.unitsStyle = .abbreviated
		
		return formatter.string(from: time)!
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
	
	func createTimeBlock(start: Date, end: Date, for day: DayInWeek) {
		let newTimeBlock = TimeBlock(startsAt: start, endsAt: end)
		
		if var weekDay = self.week[day] {
			weekDay.append(newTimeBlock)
		} else {
			self.week[day] = [newTimeBlock]
		}
	}
}
