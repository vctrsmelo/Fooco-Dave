//
//  NewContextViewController.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 29/11/17.
//

import UIKit

class NewContextViewController: UIViewController {

    private let segueToEdit = "fromNewContextToEdit"
	private let collectionCellIdentifier = "colorCell"
	private let tableCellIdentifier = "nameSuggestionCell"
	
	private let viewModel = NewContextViewModel()
	
	private var selectedColor: UIColor?
	
	@IBOutlet private weak var nameField: UITextField!
	@IBOutlet private weak var colorsCollection: UICollectionView!
	@IBOutlet private weak var suggestionsTable: UITableView!
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.hideKeyboardOnOutsideTap()
		
        self.navigationController?.navigationBar.changeFontAndTintColor(to: UIColor.Interface.iDarkBlue)
    }
	
	private func hasValidData() -> Bool {
		if let existingText = self.nameField.text {
			return !existingText.isEmpty && self.selectedColor != nil
		} else {
			return false
		}
	}

    // MARK: - Navigation
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
		if self.hasValidData() {
			self.performSegue(withIdentifier: self.segueToEdit, sender: self.viewModel.editContextViewModel(name: self.nameField.text!, color: self.selectedColor!))
		} else {
			print("Error") // TODO: Tell the user that there is missing information
		}
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == self.segueToEdit, let editViewController = segue.destination as? EditContextViewController {
			editViewController.viewModel = sender as? EditContextViewModel
		}
    }

}

// MARK: - CollectionView

extension NewContextViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.colorOptions.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionCellIdentifier, for: indexPath)
		
		cell.layer.borderColor = UIColor.Interface.iBlack.cgColor
		cell.layer.borderWidth = 0
		
		cell.backgroundColor = self.viewModel.colorOptions[indexPath.row]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		
		self.selectedColor = cell?.backgroundColor
		
		cell?.layer.borderWidth = 1
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		
		self.selectedColor = nil
		
		cell?.layer.borderWidth = 0
	}
}

// MARK: - TableView

extension NewContextViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.suggestionOptions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.tableCellIdentifier, for: indexPath)
		
		cell.textLabel?.text = self.viewModel.suggestionOptions[indexPath.row]
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		self.nameField.text = cell?.textLabel?.text
	}
	
	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		cell?.textLabel?.isHighlighted = true
	}
	
	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		cell?.textLabel?.isHighlighted = false
	}
}
