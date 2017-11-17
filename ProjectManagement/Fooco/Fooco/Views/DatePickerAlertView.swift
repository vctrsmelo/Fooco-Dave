//
//  DatePickerAlertView.swift
//  Fooco
//
//  Created by Victor S Melo on 17/11/17.
//

import UIKit

class DatePickerAlertView: UIView {

    private var _view: UIView!
    
    @IBOutlet var viewContainer: DatePickerAlertView!
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        
    }
    
    private func setDatePicker() {
        if datePicker == nil {
            return
        }
        datePicker.datePickerMode = .date
        updateIcon()
        
    }
    
    private func setTimePicker() {
        if datePicker == nil {
            return
        }
        datePicker.datePickerMode = .time
        updateIcon()
    }

    private func updateIcon() {
        clockIconImageView.isHidden = (datePicker.datePickerMode != .time)
        calendarIconImageView.isHidden = (datePicker.datePickerMode != .date)
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

