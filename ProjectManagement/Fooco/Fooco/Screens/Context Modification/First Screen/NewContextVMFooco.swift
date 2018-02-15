//
//  NewContextVMFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import Foundation
import UIKit.UIColor
import UIKit.UIImage

class NewContextVMFooco {
	
	let colorOptions = UIColor.contextColors()
	let suggestionOptions = ["College", "Health", "Home", "Work"]
    
    var color: UIColor?
    var name: String?
    
    func hasValidData() -> Bool {
        if let existingText = self.name {
            return !existingText.isEmpty && self.color != nil
        } else {
            return false
        }
    }
	
	func indexPathFor(color: UIColor?) -> IndexPath? {
		if let color = color,
			let index = self.colorOptions.index(of: color) {
			return IndexPath(row: index, section: 0)
			
		} else {
			return nil
		}
	}
	
    func editContextViewModel(with delegate: ViewModelUpdateDelegate) -> EditContextVMFooco {
        let context = Context(name: self.name!, color: self.color!, icon: UIImage())
        return EditContextVMFooco(context: context, and: delegate)
	}
}
