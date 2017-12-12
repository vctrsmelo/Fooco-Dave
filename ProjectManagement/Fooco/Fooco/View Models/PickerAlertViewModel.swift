//
//  PickerAlertViewModel.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 12/12/17.
//

import Foundation

enum AlertPickerViewMode {
	case estimatedTime
	case startingDate
	case endingDate
	case totalFocusingTime
}

class PickerAlertViewModel {
	
	var currentMode: AlertPickerViewMode
	
	var contextName: String?
	var projectName: String?
	
	private(set) var overTitle = ""
	private(set) var title = ""
	private(set) var underTitle = ""
	
	var startDate: Date? {
		didSet {
			self.configureTitles()
		}
	}
	var endDate: Date? {
		didSet {
			self.configureTitles()
		}
	}
	var chosenTime: (days: Int, hours: Int)? {
		didSet {
			self.configureTitles()
		}
	}
	
	init(with mode: AlertPickerViewMode, contextName: String?, projectName: String?) {
		self.currentMode = mode
		self.contextName = contextName == "" ? nil : contextName
		self.projectName = projectName == "" ? nil : projectName
		
		self.configureTitles()
	}
	
	private func configureTitles() {
		
		self.overTitle = NSLocalizedString("\(self.contextName ?? "Context") - \(self.projectName ?? "Project")", comment: "OverTitle for most pickerAlertView states")
		
		switch self.currentMode {
		case .estimatedTime:
			self.title = NSLocalizedString("Estimated Time", comment: "Title for .estimatedTime")
			
			self.underTitle = NSLocalizedString("\(self.chosenTime?.days ?? 0) days and \(self.chosenTime?.hours ?? 0) hours", comment: "UnderTitle for .estimatedTime")
			
		case .startingDate:
			self.title = NSLocalizedString("Starting Date", comment: "Title for .startingDate")
			
			if let start = self.startDate, let end = self.endDate {
				let daysBetween = Calendar.current.dateComponents([.day], from: start, to: end)
				
				self.underTitle = NSLocalizedString("\(daysBetween.day!) days until deadline", comment: "UnderTitle for .startingDate")
				
			} else {
				self.underTitle = ""
			}
			
		case .endingDate:
			self.title = NSLocalizedString("Ending Date", comment: "Title for .endingDate")
			
			if let start = self.startDate, let end = self.endDate {
				let daysBetween = Calendar.current.dateComponents([.day], from: start, to: end)
				
				self.underTitle = NSLocalizedString("\(daysBetween.day!) days since starting date", comment: "UnderTitle for .endingDate")
				
			} else {
				self.underTitle = ""
			}
		
		case .totalFocusingTime: // TODO: this
			self.title = NSLocalizedString("Focus Duration", comment: "Title for .totalFocusingTime")
			self.underTitle = NSLocalizedString("TODO", comment: "UnderTitle for .totalFocusingTime")
		}
	}
	
}
