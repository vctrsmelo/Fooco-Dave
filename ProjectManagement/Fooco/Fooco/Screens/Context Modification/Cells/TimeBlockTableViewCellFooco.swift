//
//  TimeBlockTableViewCellFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 08/12/17.
//

import UIKit

class TimeBlockTableViewCellFooco: UITableViewCell {

	var cellData: (timeblock: TimeBlock, days: [Weekday])? {
		didSet {
			self.fillCellData()
		}
	}
	
	@IBOutlet private weak var startTime: UILabel!
	@IBOutlet private weak var endTime: UILabel!
	@IBOutlet private weak var weekDays: UILabel!
	
	private func fillCellData() {
		if let someCellData = self.cellData {
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .none
			dateFormatter.timeStyle = .short
			
			self.startTime.text = dateFormatter.string(from: someCellData.timeblock.start.toDate())
			self.endTime.text = dateFormatter.string(from: someCellData.timeblock.end.toDate())
			
			self.weekDays.text = Weekday.weekdaysText(for: someCellData.days.sorted(), style: .normal)
		}
	}

}
