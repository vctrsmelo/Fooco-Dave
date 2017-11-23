//
//  Extensions.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import Foundation
import UIKit

extension UINavigationBar {
    func removeBackground() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIButton {
    func setTitleColor(_ color: UIColor) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .application)
        self.setTitleColor(color, for: .disabled)
        self.setTitleColor(color, for: .focused)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .reserved)
        self.setTitleColor(color, for: .selected)
    }
    
    func setTitle(_ title: String) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .application)
        self.setTitle(title, for: .disabled)
        self.setTitle(title, for: .focused)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .reserved)
        self.setTitle(title, for: .selected)
    }
}
