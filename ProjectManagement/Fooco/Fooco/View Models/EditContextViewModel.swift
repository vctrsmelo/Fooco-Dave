//
//  EditContextViewModel.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import CoreGraphics
import Foundation

enum DayInWeek: Int, Comparable {
    static func < (lhs: DayInWeek, rhs: DayInWeek) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    enum SizeStyle {
        case veryShort, short, normal
    }
    
	case sunday, monday, tuesday, wednesday, thursday, friday, saturday
	
	var string: String {
		return DateFormatter().standaloneWeekdaySymbols[self.rawValue]
	}
	
	var shortString: String {
		return DateFormatter().shortStandaloneWeekdaySymbols[self.rawValue]
	}
	
	var veryShortString: String {
		return DateFormatter().veryShortStandaloneWeekdaySymbols[self.rawValue]
	}
    
    func string(_ style: SizeStyle) -> String {
        switch style {
        case .veryShort:
            return self.veryShortString
            
        case .short:
            return self.shortString
            
        case .normal:
            return self.string
        }
    }
    
    static func weekdaysText(for days: [DayInWeek], style: SizeStyle) -> String {
        var weekdaysText = ""
        
        for day in days {
            if day == days.first {
                weekdaysText.append(NSLocalizedString("at ", comment: "weekdaysText first part"))
            } else if day == days.last {
                weekdaysText.append(NSLocalizedString(" and ", comment: "weekdaysText second to last part"))
            } else {
                weekdaysText.append(", ")
            }
            
            weekdaysText.append(day.string(style).lowercased())
        }
        
        return weekdaysText
    }
}

class EditContextViewModel {
    
    private weak var delegate: ViewModelUpdateDelegate?
	
	let context: Context
	
	private let barSize: CGFloat = 100
	
	private var week = [DayInWeek: [TimeBlock]]()
	
	private var counterWeek: [TimeBlock: [DayInWeek]] {
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
	
	func cellData(for row: Int) -> (TimeBlock, [DayInWeek]) {
		return self.counterWeek.row(row)
	}
	
	private func createTimeBlock(start: Date, end: Date, for days: Set<DayInWeek>) {
		let newTimeBlock = TimeBlock(startsAt: start, endsAt: end)
		
        for day in days {
            if self.week[day] == nil {
                self.week[day] = []
            }
            
            self.week[day]?.append(newTimeBlock)
        }
	}
	
	func createNewAlert() -> PickerAlertViewModel {
		let now = Date()
		return PickerAlertViewModel.forTimeBlocks(startingTime: now, endingTime: now.addingTimeInterval(1.hour), days: Set(), context: self.context, receiver: self)
	}
    
    func createEditAlert(for selected: (TimeBlock, [DayInWeek])) -> PickerAlertViewModel {
        let timeblock = selected.0
        let days = selected.1
        return PickerAlertViewModel.forTimeBlocks(startingTime: timeblock.startsAt, endingTime: timeblock.endsAt, days: Set(days), context: self.context, receiver: self)
    }
}

extension EditContextViewModel: PickerAlertViewModelReceiver {
	func receive(_ viewModel: PickerAlertViewModel) {
        if viewModel.mode == .timeBlock(.end) {
            self.createTimeBlock(start: viewModel.mainDate, end: viewModel.comparisonDate!, for: viewModel.selectedDays)
            
            self.delegate?.viewModelDidUpdate()
        }
	}
}
