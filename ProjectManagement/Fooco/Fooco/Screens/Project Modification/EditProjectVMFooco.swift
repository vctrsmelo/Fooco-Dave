//
//  EditProjectVMFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 13/12/17.
//

import Foundation

protocol ViewModelUpdateDelegate: AnyObject {
	func viewModelDidUpdate()
}

class EditProjectVMFooco {
	
	private weak var delegate: ViewModelUpdateDelegate?
	
	// MARK: Main Input
	private var project: Project?
	
	// MARK: Input/Output
	var chosenContext: Context?
	var name: String?
	var importance: Int = 1
	
	// MARK: Output
	var startDateString: String {
		return DateFormatter.localizedString(from: self.startingDate, dateStyle: .short, timeStyle: .none)
	}
	var endDateString: String {
		return DateFormatter.localizedString(from: self.endingDate, dateStyle: .short, timeStyle: .none)
	}
	var estimatedTimeString: String {
		return NSLocalizedString("\(self.chosenTime.days) days and \(self.chosenTime.hours) hours", comment: "Estimated time phrase")
	}
	
	// MARK: Working Data
	private var startingDate = Date()
	private var endingDate = Date().addingTimeInterval(7.days)
	private var chosenTime = (days: 0, hours: 0)
	
	init(with project: Project?, and delegate: ViewModelUpdateDelegate) {
		self.delegate = delegate
		
		self.project = project
		
		if let someProject = self.project {
			self.chosenContext = someProject.context
			
			self.name = someProject.name
			self.startingDate = someProject.startingDate
			self.endingDate = someProject.endingDate
			
            let days = Int(someProject.initialEstimatedTime) / Int(1.day)
			let hours = Int(someProject.initialEstimatedTime.truncatingRemainder(dividingBy: 1.day) / 1.hour)
			
			self.chosenTime = (days: days, hours: hours)
			self.importance = Int(someProject.importance)
		}
	}
	
    func canSaveProject() -> Bool { // TODO: All error handling (testing and giving feedback to the user), should be done here
		return self.chosenContext != nil &&
			self.name != nil &&
			self.name != "" &&
			self.chosenTime != (days: 0, hours: 0) &&
			self.startingDate < self.endingDate
	}
	
	func saveProject() {
		if self.canSaveProject(),
			let context = self.chosenContext,
			let name = self.name {
			
			let totalEstimate = self.chosenTime.days.days + self.chosenTime.hours.hours
			
			if let editedProject = self.project {
				editedProject.context = context
				editedProject.name = name
				editedProject.startingDate = self.startingDate
				editedProject.endingDate = self.endingDate
				editedProject.updateInitialEstimatedTime(totalEstimate)
				editedProject.importance = Double(self.importance)
				
				self.project = editedProject
                User.sharedInstance.updateProject(editedProject)
				
			} else {
				do {
					let newProject = try Project(name: name, starts: self.startingDate, ends: self.endingDate, context: context, importance: Double(self.importance), estimatedTime: totalEstimate)
					
					self.project = newProject
					User.sharedInstance.add(project: newProject)
					
				} catch {
					print("[Error] \(error)")
				}
			}
			
			User.sharedInstance.invalidateSchedule()
			
		} else {
			print("[Error] Could not save")
		}
	}
	
	func createAlert(for mode: PickerAlertMode) -> PickerAlertVM {
		switch mode {
		case .estimatedTime:
			return PickerAlertVM.forEstimatedTime(self.chosenTime, context: self.chosenContext, projectName: self.name, receiver: self)
		
		case .date(.begin):
			return PickerAlertVM.forStartingDate(self.startingDate, endDate: self.endingDate, context: self.chosenContext, projectName: self.name, receiver: self)
			
		case .date(.end):
			return PickerAlertVM.forEndingDate(self.endingDate, startDate: self.startingDate, context: self.chosenContext, projectName: self.name, receiver: self)
			
		case .timeBlock:
			fatalError("[Error] Mode not supported")
		}
	}
}

// MARK: - PickerAlertViewModelReceiver

extension EditProjectVMFooco: PickerAlertViewModelReceiver {
	func receive(_ viewModel: PickerAlertVM) {
		switch viewModel.mode {
		case .estimatedTime:
			self.chosenTime = viewModel.chosenTime
			
		case .date(.begin):
			self.startingDate = viewModel.mainDate
			
		case .date(.end):
			self.endingDate = viewModel.mainDate
			
		case .timeBlock:
			fatalError("[Error] Mode not supported")
		}
		
		self.delegate?.viewModelDidUpdate()
	}
}
