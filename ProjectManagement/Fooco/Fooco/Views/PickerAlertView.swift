//
//  PickerAlertView.swift
//  Fooco
//
//  Created by Victor S Melo on 17/11/17.
//

import UIKit

class PickerAlertView: UIView {
	
	var viewModel: PickerAlertViewModel!
	
	private var currentMode: PickerAlertMode {
		return self.viewModel.mode
	}
	
    private var _view: UIView!
	private var originalNavigationColor: UIColor?
	
	private var footerIsHidden = true {
		didSet {
			self.updateFooter()
		}
	}
	
    @IBOutlet private weak var viewContainer: PickerAlertView!
	
    @IBOutlet private weak var calendarIconImageView: UIImageView!
    @IBOutlet private weak var clockIconImageView: UIImageView!
	
	@IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var mainView: UIView!
	
	@IBOutlet private weak var footer: UIView!
	@IBOutlet private weak var bodyToSuperConstraint: NSLayoutConstraint!
	@IBOutlet private weak var bodyToFooterConstraint: NSLayoutConstraint!
	
	@IBOutlet private weak var overTitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var underTitleLabel: UILabel!
	
	@IBOutlet private weak var footerTitle: UILabel!
	
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var hoursPicker: UIPickerView!
	
    @IBOutlet private weak var confirmButton: UIButton!
	
	func initialSetup() {
		self.xibSetup()
		
		self.updateFooter()
		
		self.isHidden = true
	}
	
	func present(with viewModel: PickerAlertViewModel) {
        
        self.viewModel = viewModel
		
		self.updateToViewModel()
		
		self.defaultConfigurations()
		
		switch self.currentMode {
		case .estimatedTime:
			if let someEstimatedTime = self.viewModel.chosenTime {
				hoursPicker.selectRow(someEstimatedTime.days, inComponent: 0, animated: false)
				hoursPicker.selectRow(someEstimatedTime.hours, inComponent: 1, animated: false)
			}
			
			self.showHoursPicker()
			
		case .date(.begin):
			let initialDate = self.viewModel.mainDate ?? Date()
			self.datePicker.setDate(initialDate, animated: false)
			
		case .date(.end):
            self.datePicker.minimumDate = self.viewModel.comparisonDate
			
			let initialDate = (self.viewModel.mainDate ??
                self.viewModel.comparisonDate?.addingTimeInterval(7.days)) ??
                Date().addingTimeInterval(7.days)
			
			self.datePicker.setDate(initialDate, animated: false)
			
		case .timeBlock(.begin):
			self.datePicker.datePickerMode = .time
			self.datePicker.minuteInterval = 15
			
			self.datePicker.setDate(self.viewModel.mainDate ?? Date(), animated: false)
			
			self.footerIsHidden = false
			
			self.confirmButton.backgroundColor = UIColor.Interface.iDarkBlue
			self.confirmButton.setTitle("Continue", for: .normal)
			
		case .timeBlock(.end):
			self.datePicker.datePickerMode = .time
			self.datePicker.minuteInterval = 15

			self.datePicker.minimumDate = self.viewModel.mainDate?.addingTimeInterval(1.hour)
			
            self.datePicker.setDate(self.viewModel.comparisonDate ?? Date().addingTimeInterval(1.hour), animated: true)
            
            self.footerIsHidden = false
		}
		
        self.updateIcon()
        self.isHidden = false
    }
	
	/// Most common picker configurations
	private func defaultConfigurations() {
		self.showDatePicker()
        
        self.datePicker.datePickerMode = .date
        
		self.datePicker.maximumDate = nil
		self.datePicker.minimumDate = nil
        
		self.footerIsHidden = true
        
        self.confirmButton.backgroundColor = UIColor.Interface.iGreen
        self.confirmButton.setTitle("Confirm", for: .normal)
	}
	
	private func showHoursPicker() {
		hoursPicker.isHidden = false
		datePicker.isHidden = true
	}
	
	private func showDatePicker() {
		hoursPicker.isHidden = true
		datePicker.isHidden = false
	}
	
	private func updateToViewModel() {
		self.overTitleLabel.text = self.viewModel.overTitle
		self.titleLabel.text = self.viewModel.title
		self.underTitleLabel.text = self.viewModel.underTitle
	}

    private func updateIcon() {
        clockIconImageView.isHidden = hoursPicker.isHidden
        calendarIconImageView.isHidden = datePicker.isHidden
    }
	
	private func updateFooter() {
		DispatchQueue.main.async {
			self.footer.isHidden = self.footerIsHidden
			
			if self.footerIsHidden { // needed to make sure the constraints are deactivated first
				self.bodyToFooterConstraint.isActive = false
				self.bodyToSuperConstraint.isActive = true
			} else {
				self.bodyToSuperConstraint.isActive = false
				self.bodyToFooterConstraint.isActive = true
			}
			
			self.view.layoutIfNeeded()
		}
	}
	
	// TODO: hide view if touch outside it
    @IBAction func confirmTouched(_ sender: UIButton) {
		
		self.isHidden = true
        
		switch self.currentMode {
		case .estimatedTime:
			self.viewModel.chosenTime?.days = self.hoursPicker.selectedRow(inComponent: 0)
			self.viewModel.chosenTime?.hours = self.hoursPicker.selectedRow(inComponent: 1)
			
		case .date:
			self.viewModel.mainDate = self.datePicker.date
			
		case .timeBlock(.begin):
			self.viewModel.mainDate = self.datePicker.date
			self.present(with: self.viewModel.forTimeBlockEnd())
			
		case .timeBlock(.end):
			self.viewModel.comparisonDate = self.datePicker.date
		}
		
		self.viewModel.sendToReceiver()
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
		if self.currentMode == .timeBlock(.end) {
			self.viewModel.comparisonDate = sender.date
		} else {
			self.viewModel.mainDate = sender.date
		}
		
		self.updateToViewModel()
    }
}

extension PickerAlertView: XibLoader {
    var nibName: String {
        return "PickerAlertView"
    }
    
    var view: UIView! {
        get {
            return _view
        }
        set {
            _view = newValue
        }
    }
    
}

extension PickerAlertView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 1000
        case 1:
            return 24
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.viewModel.chosenTime = (days: pickerView.selectedRow(inComponent: 0), hours: pickerView.selectedRow(inComponent: 1))
		self.updateToViewModel()
    }
    
}
