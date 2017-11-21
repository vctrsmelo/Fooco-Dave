//
//  DatePickerAlertView.swift
//  Fooco
//
//  Created by Victor S Melo on 17/11/17.
//

import UIKit

enum AlertPickerViewMode {
    case estimatedTime
    case startingDate
    case deadlineDate
    case totalFocusingTime
}

protocol DatePickerAlertViewDelegate {
    func confirmTouchedWith(_ sender: UIDatePicker)
}

class DatePickerAlertView: UIView {

    private var _view: UIView!
    
    @IBOutlet var viewContainer: DatePickerAlertView!
    
    @IBOutlet weak var calendarIconImageView: UIImageView!
    @IBOutlet weak var clockIconImageView: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overTitleLabel: UILabel!
    @IBOutlet weak var underTitleLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hoursPicker: UIPickerView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var overlayView: UIView!
    
    var delegate: DatePickerAlertViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func present(_ mode: AlertPickerViewMode) {
        
        
        
        hoursPicker.delegate = self
        hoursPicker.dataSource = self
        
        updateTextLabels(mode: mode)
        
        if mode == .estimatedTime || mode == .totalFocusingTime {
            hoursPicker.isHidden = false
            datePicker.isHidden = true
        } else {
            hoursPicker.isHidden = true
            datePicker.isHidden = false
        }

        updateIcon()
        self.isHidden = false
        
    }
    
    private func updateTextLabels(mode: AlertPickerViewMode) {
        
        switch mode {
        case .totalFocusingTime:
            titleLabel.text = "Total Focusing Time"
            overTitleLabel.text = ""
            underTitleLabel.text = ""
            break
        case .estimatedTime:
            titleLabel.text = "Estimated Time"
            overTitleLabel.text = ""
            underTitleLabel.text = "0 days and 0 hours"
            break
        case .startingDate:
            titleLabel.text = "Starting Date"
            overTitleLabel.text = ""
            underTitleLabel.text = ""
            break
        case .deadlineDate:
            titleLabel.text = "Deadline Date"
            overTitleLabel.text = ""
            underTitleLabel.text = ""
            break
        }
        
    }
    
    func configure() {
        guard let superview = self.superview else {
            return
            
        }
        
        overlayView.frame = superview.frame
        
        //shadow
        
        backgroundView.layer.shadowOpacity = 0.30
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowRadius = 6
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.masksToBounds = false
        
        confirmButton.layer.shadowOpacity = 0.30
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        confirmButton.layer.shadowRadius = 6
        confirmButton.layer.shadowColor = UIColor.black.cgColor
        confirmButton.layer.masksToBounds = false
        
        self.isHidden = true

    }

    private func updateIcon() {
        clockIconImageView.isHidden = (datePicker.datePickerMode != .time)
        calendarIconImageView.isHidden = (datePicker.datePickerMode != .date)
    }
    
    @IBAction func confirmTouched(_ sender: UIButton) {
        self.isHidden = true
        delegate?.confirmTouchedWith(datePicker)
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
        var value = row
        return "\(row)"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        underTitleLabel.text = "\(pickerView.selectedRow(inComponent: 0)) days and \(pickerView.selectedRow(inComponent: 1)) hours"
        
    }
    
}

