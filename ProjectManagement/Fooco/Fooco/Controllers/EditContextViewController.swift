//
//  EditContextViewController.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import UIKit

class EditContextViewController: UIViewController {

	var viewModel: EditContextViewModel!
	
	private let cellIdentifier = "timeblockCell"
	
	// MARK: - Outlets

	@IBOutlet private weak var contextTimeQuestionLabel: UILabel!
	@IBOutlet private weak var totalWeekTimeLabel: UILabel!
	@IBOutlet private weak var tableView: UITableView!
	
	// MARK: Sunday
	@IBOutlet private weak var sundayTime: UILabel!
	@IBOutlet private weak var sundayBarHeight: NSLayoutConstraint!
	
	// MARK: Monday
	@IBOutlet private weak var mondayTime: UILabel!
	@IBOutlet private weak var mondayBarHeight: NSLayoutConstraint!
	
	// MARK: Tuesday
	@IBOutlet private weak var tuesdayTime: UILabel!
	@IBOutlet private weak var tuesdayBarHeight: NSLayoutConstraint!
	
	// MARK: Wednesday
	@IBOutlet private weak var wednesdayTime: UILabel!
	@IBOutlet private weak var wednesdayBarHeight: NSLayoutConstraint!
	
	// MARK: Thursday
	@IBOutlet private weak var thursdayTime: UILabel!
	@IBOutlet private weak var thursdayBarHeight: NSLayoutConstraint!
	
	// MARK: Friday
	@IBOutlet private weak var fridayTime: UILabel!
	@IBOutlet private weak var fridayBarHeight: NSLayoutConstraint!
	
	// MARK: Saturday
	@IBOutlet private weak var saturdayTime: UILabel!
	@IBOutlet private weak var saturdayBarHeight: NSLayoutConstraint!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.contextTimeQuestionLabel.text = String(format: NSLocalizedString("When are you available to do %@'s activities", comment: "Top of new context second screen"), self.viewModel.context.name)
		
		self.totalWeekTimeLabel.text = self.viewModel.totalWeeklyTimeDescription
		
		self.updateBars()
    }
	
	private func updateBars() {
		self.sundayTime.text = self.viewModel.timeDescription(for: .sunday)
		self.sundayBarHeight.constant = self.viewModel.size(for: .sunday)
		
		self.mondayTime.text = self.viewModel.timeDescription(for: .monday)
		self.mondayBarHeight.constant = self.viewModel.size(for: .monday)
		
		self.tuesdayTime.text = self.viewModel.timeDescription(for: .tuesday)
		self.tuesdayBarHeight.constant = self.viewModel.size(for: .tuesday)
		
		self.wednesdayTime.text = self.viewModel.timeDescription(for: .wednesday)
		self.wednesdayBarHeight.constant = self.viewModel.size(for: .wednesday)
		
		self.thursdayTime.text = self.viewModel.timeDescription(for: .thursday)
		self.thursdayBarHeight.constant = self.viewModel.size(for: .thursday)
		
		self.fridayTime.text = self.viewModel.timeDescription(for: .friday)
		self.fridayBarHeight.constant = self.viewModel.size(for: .friday)
		
		self.saturdayTime.text = self.viewModel.timeDescription(for: .saturday)
		self.saturdayBarHeight.constant = self.viewModel.size(for: .saturday)
	}
	
	@IBAction func addContextTimes() {
		
	}

}

// MARK: - Tableview

extension EditContextViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.totalRows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
		
		return cell
	}
}
