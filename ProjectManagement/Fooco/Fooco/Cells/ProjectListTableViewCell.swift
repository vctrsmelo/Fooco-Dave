//
//  ProjectListTableViewCell.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 26/11/17.
//

import UIKit

class ProjectListTableViewCell: UITableViewCell {

	static let identifier = "projectCell"
	
	var project: Project? {
		didSet {
			self.fillProjectData()
		}
	}
	
	@IBOutlet private weak var timeLeft: UILabel!
	@IBOutlet private weak var projectName: UILabel!
	@IBOutlet private weak var contextName: UILabel!
	@IBOutlet private weak var deadlineDate: UILabel!
	
	private func fillProjectData() {
		if let someProject = self.project {
			self.timeLeft.text = String(format: NSLocalizedString("%dh left", comment: "Time left for projects"), Int(someProject.timeLeftEstimated.inHours))
			
			self.projectName.text = someProject.name
			self.contextName.text = someProject.context.name
			
			let dateFormater = DateFormatter()
			dateFormater.timeStyle = .none
			dateFormater.dateStyle = .short
			dateFormater.doesRelativeDateFormatting = true
			
			self.deadlineDate.text = dateFormater.string(from: someProject.endingDate)
		}
	}

}
