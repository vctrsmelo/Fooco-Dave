//
//  DatePickerAlertView.swift
//  Fooco
//
//  Created by Victor S Melo on 17/11/17.
//

import UIKit

protocol DatePickerAlertViewDelegate: AnyObject {
    func confirmTouched(_ sender: UIDatePicker, for mode: AlertPickerViewMode)
    func confirmTouched(_ sender: UIPickerView, for mode: AlertPickerViewMode)
    func dateChanged(_ sender: UIDatePicker, at alertView: DatePickerAlertView, for mode: AlertPickerViewMode)
}

class DatePickerAlertView: UIView {

	weak var delegate: DatePickerAlertViewDelegate?
	
	private var currentMode: AlertPickerViewMode {
		return self.viewModel.currentMode
	}
	
	var viewModel: PickerAlertViewModel!
	
    private var _view: UIView!
	private var originalNavigationColor: UIColor?
	
	private var footerIsHidden = true {
		didSet {
			self.updateFooter()
		}
	}
	
    @IBOutlet private weak var viewContainer: DatePickerAlertView!
	
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
	
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hoursPicker: UIPickerView!
	
    @IBOutlet private weak var confirmButton: UIButton!
    
	func present(with viewModel: PickerAlertViewModel) {
        
        self.viewModel = viewModel
		
		self.overTitleLabel.text = self.viewModel.overTitle
		self.titleLabel.text = self.viewModel.title
		self.underTitleLabel.text = self.viewModel.underTitle
        
        hoursPicker.delegate = self
        hoursPicker.dataSource = self
        
        if currentMode == .estimatedTime || currentMode == .totalFocusingTime {
            hoursPicker.isHidden = false
            datePicker.isHidden = true
            
            if let someEstimatedTime = self.viewModel.chosenTime {
//                let hours: Int = Int(someEstimatedTime / 1.hour)
//                let days: Int = Int(someEstimatedTime / 1.day)
				
                hoursPicker.selectRow(someEstimatedTime.days, inComponent: 0, animated: false)
                hoursPicker.selectRow(someEstimatedTime.hours, inComponent: 1, animated: false)
            }
            
        } else {
            hoursPicker.isHidden = true
            datePicker.isHidden = false
			
			if self.currentMode == .endingDate {
				self.datePicker.minimumDate = self.viewModel.startDate
				self.datePicker.maximumDate = nil
			} else if self.currentMode == .startingDate {
				self.datePicker.maximumDate = self.viewModel.endDate
				self.datePicker.minimumDate = nil
			}
			
			// TODO: This
//            if initialDate != nil {
//                datePicker.setDate(initialDate!, animated: false)
//            }
			
        }
		
        updateIcon()
        self.isHidden = false
        
    }
    
    func configure() {
        guard let superview = self.superview else {
            return
        }
        
        overlayView.frame = superview.frame
        
        //shadow
        
        mainView.layer.shadowOpacity = 0.30
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainView.layer.shadowRadius = 6
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.masksToBounds = false
        
        confirmButton.layer.shadowOpacity = 0.30
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        confirmButton.layer.shadowRadius = 6
        confirmButton.layer.shadowColor = UIColor.black.cgColor
        confirmButton.layer.masksToBounds = false
		
		self.updateFooter()
        
        self.isHidden = true
    }
	
	private func updateLabels() {
		
	}

    private func updateIcon() {
        clockIconImageView.isHidden = hoursPicker.isHidden
        calendarIconImageView.isHidden = datePicker.isHidden
    }
	
	private func updateFooter() {
		DispatchQueue.main.async {
			self.footer.isHidden = self.footerIsHidden
			
			if self.footerIsHidden { // need to make sure the constraints are deactivated first
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
        
        if currentMode == .estimatedTime || currentMode == .totalFocusingTime {
            delegate?.confirmTouched(hoursPicker, for: currentMode)
        } else {
            delegate?.confirmTouched(datePicker, for: currentMode)
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        delegate?.dateChanged(sender, at: self, for: currentMode)
    }
}

extension DatePickerAlertView: XibLoader {
    var nibName: String {
        return "DatePickerAlertView"
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

extension DatePickerAlertView: UIPickerViewDataSource, UIPickerViewDelegate {
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
        underTitleLabel.text = "\(pickerView.selectedRow(inComponent: 0)) days and \(pickerView.selectedRow(inComponent: 1)) hours"
    }
    
}
