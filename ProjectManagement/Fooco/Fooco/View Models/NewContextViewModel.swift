//
//  NewContextViewModel.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 30/11/17.
//

import UIKit

class NewContextViewModel {
	
	let colorOptions = UIColor.contextColors()
	let suggestionOptions = ["College", "Health", "Home", "Work"]
	
	func editContextViewModel(name: String, color: UIColor) -> EditContextViewModel {
		return EditContextViewModel(name: name, color: color)
	}
}
