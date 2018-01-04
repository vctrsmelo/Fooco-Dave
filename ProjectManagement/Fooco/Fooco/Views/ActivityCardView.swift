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
//		self.startTime.text = self.data?.timeBlock.startsAt.toString(dateStyle: .none, timeStyle: .short)
        
        if let data = self.data {
            self.startTime.text = "\(data.timeBlock.start.hour):\(data.timeBlock.start.minute)"
            self.deadlineTime.text = "\(data.timeBlock.end.hour):\(data.timeBlock.end.minute)"
            self.context.text = data.project?.context.name ?? ""
            self.project.text = data.project?.name ?? data.name!

            self.focusTime.text = "\(data.timeBlock.length.inHours)"

        }
        
        
	}
}
