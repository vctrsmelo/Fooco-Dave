//
//  UIViewExtension.swift
//  ProjectManagement
//
//  Created by Rodrigo Cardoso Buske on 03/11/17.
//

import UIKit

extension UIView {
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
		}
	}
	
}
