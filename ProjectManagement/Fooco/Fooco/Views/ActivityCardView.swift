//
//  ActivityCardView.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 22/11/17.
//

import UIKit

class ActivityCardView: UIView {
	
	var data: Activity? {
		didSet {
			self.dataManager()
		}
	}

	@IBOutlet private weak var startTime: UILabel!
	@IBOutlet private weak var deadlineTime: UILabel!
	@IBOutlet private weak var context: UILabel!
	@IBOutlet private weak var project: UILabel!
	@IBOutlet private weak var focusTime: UILabel!

	private func dataManager() {
		self.startTime.text = self.data?.timeBlock.startsAt.toString(dateStyle: .none, timeStyle: .short)
		self.deadlineTime.text = self.data?.timeBlock.endsAt.toString(dateStyle: .none, timeStyle: .short)
		self.context.text = self.data?.project.context.name
		self.project.text = self.data?.project.name
		
		self.focusTime.text = self.string(of: self.data?.timeBlock.totalTime)
	}
	
	private func string(of time: TimeInterval?) -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour, .minute]
		formatter.unitsStyle = .abbreviated
		formatter.maximumUnitCount = 2
		
		return formatter.string(from: time ?? 0)!
	}
}
