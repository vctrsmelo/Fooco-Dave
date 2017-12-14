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

final class PickerAlertViewModel {
	
	var currentMode: AlertPickerViewMode
	
	var projectName: String?
	var context: Context?
	
	private(set) var overTitle = ""
	private(set) var title = ""
	private(set) var underTitle = ""
	
	var mainDate: Date? {
		didSet {
			self.configureTitles()
		}
	}
	var comparisonDate: Date? {
		didSet {
			self.configureTitles()
		}
	}
	var chosenTime: (days: Int, hours: Int)? {
		didSet {
			self.configureTitles()
		}
	}
	
	// MARK: - Initialization
	
	private init(mode: AlertPickerViewMode, context: Context?, projectName: String?, mainDate: Date? = nil, comparisonDate: Date? = nil, chosenTime: (days: Int, hours: Int)? = nil) {
		self.currentMode = mode
		self.context = context
		self.projectName = projectName == "" ? nil : projectName
		self.mainDate = mainDate
		self.comparisonDate = comparisonDate
		self.chosenTime = chosenTime
		
		self.configureTitles()
	}
	
	static func forEstimatedTime(_ chosenTime: (days: Int, hours: Int)?, context: Context?, projectName: String?) -> PickerAlertViewModel {
		return self.init(mode: .estimatedTime, context: context, projectName: projectName, chosenTime: chosenTime)
	}
	
	static func forStartingDate(_ startDate: Date?, endDate: Date?, context: Context?, projectName: String?) -> PickerAlertViewModel {
		return self.init(mode: .startingDate, context: context, projectName: projectName, mainDate: startDate, comparisonDate: endDate)
	}
	
	static func forEndingDate(_ endDate: Date?, startDate: Date?, context: Context?, projectName: String?) -> PickerAlertViewModel {
		return self.init(mode: .endingDate, context: context, projectName: projectName, mainDate: endDate, comparisonDate: startDate)
	}
	
	// MARK: - Prepare Output to View
	
	private func configureTitles() {
		
		self.overTitle = NSLocalizedString("\(self.context?.name ?? "Context") - \(self.projectName ?? "Project")", comment: "OverTitle for most pickerAlertView states")
		
		switch self.currentMode {
		case .estimatedTime:
			self.title = NSLocalizedString("Estimated Time", comment: "Title for .estimatedTime")
			
			self.underTitle = NSLocalizedString("\(self.chosenTime?.days ?? 0) days and \(self.chosenTime?.hours ?? 0) hours", comment: "UnderTitle for .estimatedTime")
			
		case .startingDate:
			self.title = NSLocalizedString("Starting Date", comment: "Title for .startingDate")
			
			if let start = self.mainDate, let end = self.comparisonDate {
				let daysBetween = Calendar.current.dateComponents([.day], from: start, to: end)
				
				if daysBetween.day! >= 0 {
					self.underTitle = NSLocalizedString("\(daysBetween.day!) days until deadline", comment: "UnderTitle for .startingDate")
					
				} else {
					self.underTitle = ""
				}
				
				
				
			} else {
				self.underTitle = ""
			}
			
		case .endingDate:
			self.title = NSLocalizedString("Ending Date", comment: "Title for .endingDate")
			
			if let start = self.comparisonDate, let end = self.mainDate {
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
