//
//  EditProjectViewModel.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 13/12/17.
//

import Foundation

class EditProjectViewModel {
	
	private var project: Project?
	
	var chosenContext: Context?
	
	var name: String?
	var importance: Int = 1
	
	private var startingDate: Date?
	private var endingDate: Date?
	private var chosenTime: (days: Int, hours: Int)?
	
	init(with project: Project? = nil) {
		self.project = project
		
		if let someProject = self.project {
			self.chosenContext = someProject.context
			
			self.name = someProject.name
			self.startingDate = someProject.startingDate
			self.endingDate = someProject.endingDate
			
			let days = Int(someProject.totalTimeEstimated) / Int(1.day)
			let hours = Int(someProject.totalTimeEstimated.truncatingRemainder(dividingBy: 1.day) / 1.hour)
			
			self.chosenTime = (days: days, hours: hours)
			self.importance = someProject.importance
		}
	}
	
	func canSaveProject() -> Bool {
		return self.chosenContext != nil &&
			self.name != nil && self.name != "" &&
			self.startingDate != nil &&
			self.endingDate != nil &&
			self.chosenTime != nil
	}
	
	func saveProject() {
		if self.canSaveProject(),
			let context = self.chosenContext,
			let name = self.name,
			let start = self.startingDate,
			let end = self.endingDate,
			let estimate = self.chosenTime {
			
			let totalEstimate = estimate.days.days + estimate.hours.hours
			
			if let editedProject = self.project {
				editedProject.context = context
				editedProject.name = name
				editedProject.startingDate = start
				editedProject.endingDate = end
				editedProject.totalTimeEstimated = totalEstimate
				editedProject.importance = self.importance
				
				self.project = editedProject
				let index = User.sharedInstance.projects.index(of: editedProject) // TODO: Give id to projects and make this better
				User.sharedInstance.projects[index!] = editedProject
				
			} else {
				let newProject = Project(named: name, startsAt: start, endsAt: end, withContext: context, importance: importance, totalTimeEstimated: totalEstimate)
				
				self.project = newProject
				User.sharedInstance.add(projects: [newProject])
			}
			
			User.sharedInstance.isCurrentScheduleUpdated = false
			
		} else {
			// TODO: Error message
		}
	}
	
	func createAlert(for mode: AlertPickerViewMode) -> PickerAlertViewModel {
		switch mode {
		case .estimatedTime:
			return PickerAlertViewModel.forEstimatedTime(self.chosenTime, context: self.chosenContext, projectName: self.name)
		
		case .startingDate:
			return PickerAlertViewModel.forStartingDate(self.startingDate, endDate: self.endingDate, context: self.chosenContext, projectName: self.name)
			
		case .endingDate:
			return PickerAlertViewModel.forEndingDate(self.endingDate, startDate: self.startingDate, context: self.chosenContext, projectName: self.name)
			
		case .totalFocusingTime:
			fatalError() // TODO: this
		}
	}
}
