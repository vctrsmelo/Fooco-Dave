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
	
	var counterWeek: [TimeBlock: [DayInWeek]] {
		var value = [TimeBlock: [DayInWeek]]()
		
		for day in self.week {
			for block in day.value {
				if value[block] == nil {
					value[block] = []
				}
				
				value[block]?.append(day.key)
			}
		}
		
		return value
	}
	
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
	
	var totalRows: Int {
		return self.counterWeek.count
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
		let time = self.time(for: day)
		
		var result: String
		
		if time != 0 {
			result = self.timeFormater(time)
		} else {
			result = ""
		}
		
		return result
	}
	
	func size(for day: DayInWeek) -> CGFloat {
		let dayTime = self.time(for: day)
		
		let size = CGFloat(dayTime / self.busiestDayTotalTime)
		
		return size * self.barSize
	}
	
	func createTimeBlock(start: Date, end: Date, for day: DayInWeek) {
		let newTimeBlock = TimeBlock(startsAt: start, endsAt: end)
		
		if self.week[day] == nil {
			self.week[day] = []
		}
		
		self.week[day]?.append(newTimeBlock)
	}
}
