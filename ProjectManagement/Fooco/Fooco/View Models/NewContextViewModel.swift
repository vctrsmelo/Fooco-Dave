//
//  NewContextViewModel.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import Foundation
import UIKit.UIColor

class NewContextViewModel {
	
	let colorOptions = UIColor.contextColors()
	let suggestionOptions = ["College", "Health", "Home", "Work"]
	
	func editContextViewModel(name: String, color: UIColor) -> EditContextViewModel {
		let context = Context(named: name, color: color, icon: nil, projects: nil, minProjectWorkingTime: 1, maximumWorkingHoursPerProject: 4)
		return EditContextViewModel(context: context)
	}
}
