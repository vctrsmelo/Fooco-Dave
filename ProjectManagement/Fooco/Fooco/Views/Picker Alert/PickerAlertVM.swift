//
//  PickerAlertVM.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 12/12/17.
//

import Foundation
import UIKit.UIColor

enum PickerAlertMode: Equatable {
	enum Stage {
		case begin
		case end
	}
	
	case estimatedTime
	case date(Stage)
	case timeBlock(Stage)
	
	static func == (lhs: PickerAlertMode, rhs: PickerAlertMode) -> Bool {
		switch (lhs, rhs) {
		case (.estimatedTime, .estimatedTime):
			return true
			
		case let (.date(stageLhs), .date(stageRhs)):
			return stageLhs == stageRhs
			
		case let (.timeBlock(stageLhs), .timeBlock(stageRhs)):
			return stageLhs == stageRhs
		
		// These are added so the default case is not need and the compiler always warns if a new case is added
		case (.estimatedTime, _):
			return false
			
		case (.date, _):
			return false
			
		case (.timeBlock, _):
			return false
		}
	}
}

protocol PickerAlertViewModelReceiver: AnyObject {
	func receive(_ viewModel: PickerAlertVM)
}

final class PickerAlertVM {
	
    /// Basically a delegate
	private weak var receiver: PickerAlertViewModelReceiver?
	
	// MARK: Input
	private(set) var mode: PickerAlertMode
	
	private(set) var projectName: String?
	private(set) var context: Context?
	
	private(set) var selectedDays = Set<Weekday>()
	
	// MARK: Output
    let tagAdd = 100 // The tags start at 100 to diferentiate from not tagged items
    
	private(set) var overTitle = ""
	private(set) var title = ""
	private(set) var underTitle = ""
	private(set) var footerTitle = ""
    private(set) var button = (title: "", color: UIColor.Interface.iGreen)
	
	// MARK: Input/Output
	var mainDate: Date {
		didSet {
			self.configureOutputs()
		}
	}
	var comparisonDate: Date? {
		didSet {
			self.configureOutputs()
		}
	}
	var chosenTime: (days: Int, hours: Int) {
		didSet {
			self.configureOutputs()
		}
	}
	
	// MARK: - Initialization
	
    private init(mode: PickerAlertMode, context: Context?, projectName: String?, mainDate: Date = Date(), comparisonDate: Date? = nil, chosenTime: (days: Int, hours: Int) = (days: 0, hours: 0), receiver: PickerAlertViewModelReceiver) {
		self.receiver = receiver
		
		self.mode = mode
		self.context = context
		self.projectName = projectName == "" ? nil : projectName
		self.mainDate = mainDate
		self.comparisonDate = comparisonDate
		self.chosenTime = chosenTime
		
		self.configureOutputs()
	}
	
	static func forEstimatedTime(_ chosenTime: (days: Int, hours: Int), context: Context?, projectName: String?, receiver: PickerAlertViewModelReceiver) -> PickerAlertVM {
		return self.init(mode: .estimatedTime, context: context, projectName: projectName, chosenTime: chosenTime, receiver: receiver)
	}
	
	static func forStartingDate(_ startDate: Date, endDate: Date?, context: Context?, projectName: String?, receiver: PickerAlertViewModelReceiver) -> PickerAlertVM {
		return self.init(mode: .date(.begin), context: context, projectName: projectName, mainDate: startDate, comparisonDate: endDate, receiver: receiver)
	}
	
	static func forEndingDate(_ endDate: Date, startDate: Date?, context: Context?, projectName: String?, receiver: PickerAlertViewModelReceiver) -> PickerAlertVM {
		return self.init(mode: .date(.end), context: context, projectName: projectName, mainDate: endDate, comparisonDate: startDate, receiver: receiver)
	}
	
	static func forTimeBlocks(startingTime: Date, endingTime: Date?, days: Set<Weekday>, context: Context, receiver: PickerAlertViewModelReceiver) -> PickerAlertVM {
		let returnValue = self.init(mode: .timeBlock(.begin), context: context, projectName: nil, mainDate: startingTime, comparisonDate: endingTime, receiver: receiver)
		
		returnValue.selectedDays = days
		
		return returnValue
	}
	
	func forTimeBlockEnd() -> PickerAlertVM {
		self.mode = .timeBlock(.end)
		self.configureOutputs()
		
		return self
	}
	
	func sendToReceiver() {
		self.receiver?.receive(self)
	}
	
	// MARK: - Prepare Output to View
    
    func dayTouched(tag: Int) {
        if let day = Weekday(rawValue: tag - self.tagAdd) {
            if self.selectedDays.contains(day) {
                self.selectedDays.remove(day)
                
            } else {
                self.selectedDays.insert(day)
            }
        }
        
        self.configureOutputs()
    }
	
	private func configureOutputs() {
		
		self.overTitle = NSLocalizedString("\(self.context?.name ?? "Context") - \(self.projectName ?? "Project")", comment: "OverTitle for most pickerAlertView states")
        self.button.title = NSLocalizedString("Confirm", comment: "Button Title for most pickerAlertView states")
        self.button.color = UIColor.Interface.iGreen
        
        if self.selectedDays.isEmpty {
            self.footerTitle = NSLocalizedString("choose one or more days", comment: "FooterTitle for .timeBlock(.begin), with empty days set")
        } else {
            self.footerTitle = Weekday.weekdaysText(for: self.selectedDays.sorted(), style: .short)
        }
		
		switch self.mode {
		case .estimatedTime:
			self.title = NSLocalizedString("Estimated Time", comment: "Title for .estimatedTime")
			
			self.underTitle = NSLocalizedString("\(self.chosenTime.days) days and \(self.chosenTime.hours) hours", comment: "UnderTitle for .estimatedTime")
			
		case .date(.begin):
			self.title = NSLocalizedString("Starting Date", comment: "Title for .date(.begin)")
			
			if let end = self.comparisonDate {
                let start = self.mainDate
				let daysBetween = Calendar.current.dateComponents([.day], from: start, to: end)
                self.underTitle = NSLocalizedString("\(daysBetween.day!) days until deadline", comment: "UnderTitle for .date(.begin)")
				
			} else {
				self.underTitle = ""
			}
			
		case .date(.end):
			self.title = NSLocalizedString("Ending Date", comment: "Title for .date(.end)")
			
			if let start = self.comparisonDate {
				let end = self.mainDate
                let daysBetween = Calendar.current.dateComponents([.day], from: start, to: end)
				self.underTitle = NSLocalizedString("\(daysBetween.day!) days since starting date", comment: "UnderTitle for .date(.end)")
				
			} else {
				self.underTitle = ""
			}
			
		case .timeBlock(.begin):
			self.overTitle = NSLocalizedString("\(self.context!.name)'s Available Time", comment: "OverTitle for .timeBlock(.begin)")
			self.title = NSLocalizedString("Starts at", comment: "Title for .timeBlock(.begin)")
			self.underTitle = ""
			self.button.title = NSLocalizedString("Continue", comment: "Button Title for .timeBlock(.begin)") // That's the only case with a different button for now
            self.button.color = UIColor.Interface.iDarkBlue
			
		case .timeBlock(.end):
			self.overTitle = NSLocalizedString("\(self.context!.name)'s Available Time", comment: "OverTitle for .timeBlock(.end)")
			self.title = NSLocalizedString("Ends at", comment: "Title for .timeBlock(.end)")
			
			let hoursBetween = Calendar.current.dateComponents([.hour], from: self.mainDate, to: self.comparisonDate!)
			self.underTitle = NSLocalizedString("\(hoursBetween.hour!) hours of available time", comment: "Title for .timeBlock(.end)")
		}
	}
	
}
