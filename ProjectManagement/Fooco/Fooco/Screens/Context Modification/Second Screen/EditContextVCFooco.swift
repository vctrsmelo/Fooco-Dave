//
//  EditContextVCFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import UIKit

class EditContextVCFooco: UIViewController {

	var viewModel: EditContextVMFooco!
	
	private let cellIdentifier = "timeblockCell"
	
	// MARK: - Outlets

	@IBOutlet private weak var contextTimeQuestionLabel: UILabel!
	@IBOutlet private weak var totalWeekTimeLabel: UILabel!
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var pickerAlertView: PickerAlertView!
	
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
		
		self.pickerAlertView.initialSetup()
		
		self.updateToViewModel()
    }
    
    private func updateToViewModel() {
        self.contextTimeQuestionLabel.text = String(format: NSLocalizedString("When are you available to do %@'s activities", comment: "Top of new context second screen"), self.viewModel.context.name)
        
        self.totalWeekTimeLabel.text = self.viewModel.totalWeeklyTimeDescription
        
        self.updateBars()
        
        self.tableView.reloadData()
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
	
	@IBAction private func addContextTimes() {
		self.pickerAlertView.present(with: self.viewModel.createNewAlert())
	}
}

// MARK: - ViewModelUpdateDelegate

extension EditContextVCFooco: ViewModelUpdateDelegate {
    func viewModelDidUpdate() {
        self.updateToViewModel()
    }
}

// MARK: - Tableview

extension EditContextVCFooco: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.totalRows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
		
		if let someCell = cell as? TimeBlockTableViewCellFooco {
			someCell.cellData = self.viewModel.cellData(for: indexPath.row)
			cell = someCell
		}
		
		return cell
	}
}
