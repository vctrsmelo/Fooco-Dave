//
//  TimeBlockTableViewCell.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 08/12/17.
//

import UIKit

class TimeBlockTableViewCell: UITableViewCell {

	var cellData: (timeblock: TimeBlock, days: [DayInWeek])? {
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
			
			//self.startTime.text = dateFormatter.string(from: someCellData.timeblock.start) // CHECK
            self.startTime.text = someCellData.timeblock.start.description
			//self.endTime.text = dateFormatter.string(from: someCellData.timeblock.endsAt)
			self.endTime.text = someCellData.timeblock.end.description
            
			self.weekDays.text = DayInWeek.weekdaysText(for: someCellData.days.sorted(), style: .normal)
		}
	}

}
