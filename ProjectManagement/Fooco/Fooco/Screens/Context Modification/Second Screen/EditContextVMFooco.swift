//
//  EditContextVMFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import CoreGraphics
import Foundation

class EditContextVMFooco {
    
    private weak var delegate: ViewModelUpdateDelegate?
	
	let context: Context
	
	private let barSize: CGFloat = 100
	
	private var week = [Weekday: [TimeBlock]]()
	
	private var counterWeek: [TimeBlock: [Weekday]] {
		var value = [TimeBlock: [Weekday]]()
		
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
	
    init(context: Context, and delegate: ViewModelUpdateDelegate) {
		self.context = context
        self.delegate = delegate
		
		self.loadData()
	}
	
    private func loadData() { // TODO: actually load it
	}
	
	private func timeFormater(_ time: TimeInterval) -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute]
		formatter.unitsStyle = .abbreviated
		
		return formatter.string(from: time)!
	}
	
	private func time(for day: Weekday) -> TimeInterval {
		var totalTime: TimeInterval = 0
		
		if let someDay = self.week[day] {
			for someTime in someDay {
				totalTime += someTime.length // TODO: CHECK
			}
		}
		
		return totalTime
	}
	
	func timeDescription(for day: Weekday) -> String {
		let time = self.time(for: day)
		
		var result: String
		
		if time != 0 {
			result = self.timeFormater(time)
		} else {
			result = ""
		}
		
		return result
	}
	
	func size(for day: Weekday) -> CGFloat {
		let dayTime = self.time(for: day)
		
		let size = CGFloat(dayTime / self.busiestDayTotalTime)
		
		return size * self.barSize
	}
	
	func cellData(for row: Int) -> (TimeBlock, [Weekday]) {
		return self.counterWeek.row(row)
	}
	
	private func createTimeBlock(start: Date, end: Date, for days: Set<Weekday>) {
		let newTimeBlock = try! TimeBlock(starts: Time(date: start), ends: Time(date: end)) // TODO: CHECK
		
        for day in days {
            if self.week[day] == nil {
                self.week[day] = []
            }
            
            self.week[day]?.append(newTimeBlock)
        }
	}
	
	func createNewAlert() -> PickerAlertVM {
		let now = Date()
		return PickerAlertVM.forTimeBlocks(startingTime: now, endingTime: now.addingTimeInterval(1.hour), days: Set(), context: self.context, receiver: self)
	}
    
    func createEditAlert(for selected: (TimeBlock, [Weekday])) -> PickerAlertVM {
        let timeblock = selected.0
        let days = selected.1
		return PickerAlertVM.forTimeBlocks(startingTime: timeblock.start.toDate(), endingTime: timeblock.end.toDate(), days: Set(days), context: self.context, receiver: self) // TODO: CHECK
    }
}

extension EditContextVMFooco: PickerAlertViewModelReceiver {
	func receive(_ viewModel: PickerAlertVM) {
        if viewModel.mode == .timeBlock(.end) {
            self.createTimeBlock(start: viewModel.mainDate, end: viewModel.comparisonDate!, for: viewModel.selectedDays)
            
            self.delegate?.viewModelDidUpdate()
        }
	}
}
