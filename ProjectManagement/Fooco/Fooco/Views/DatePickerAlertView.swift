//
//  DatePickerAlertView.swift
//  Fooco
//
//  Created by Victor S Melo on 17/11/17.
//

import UIKit

class DatePickerAlertView: UIView {

    @IBOutlet weak var calendarIconImageView: UIImageView!
    @IBOutlet weak var clockIconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overTitleLabel: UILabel!
    @IBOutlet weak var underTitleLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    private var _isTime: Bool = false
    @IBInspectable var isTime: Bool {
        set {
            _isTime = newValue
            
            (newValue == false) ? setDatePicker() : setTimePicker()
            
        }
        get {
            return _isTime
        }
    }
    
    private func setDatePicker() {
        datePicker.datePickerMode = .date
        updateIcon()
        
    }
    
    private func setTimePicker() {
        datePicker.datePickerMode = .time
        updateIcon()
    }

    private func updateIcon() {
        clockIconImageView.isHidden = (datePicker.datePickerMode != .time)
        calendarIconImageView.isHidden = (datePicker.datePickerMode != .date)
    }
    
}
