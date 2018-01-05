//
//  NewContextViewModel.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import Foundation
import UIKit.UIColor
import UIKit.UIImage

class NewContextViewModel {
	
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
	
    func editContextViewModel(with delegate: ViewModelUpdateDelegate) -> EditContextViewModel {
		//let context = Context(named: self.name!, color: self.color!, icon: nil, projects: nil, minProjectWorkingTime: 1, maximumWorkingHoursPerProject: 4)
        let context = Context(name: self.name!, color: self.color!, icon: UIImage()) // CHECK
        return EditContextViewModel(context: context, and: delegate)
	}
}
