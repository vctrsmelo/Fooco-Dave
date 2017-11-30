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
	
	@IBOutlet private weak var nameField: UITextField!
	@IBOutlet private weak var colorsCollection: UICollectionView!
	@IBOutlet private weak var suggestionsTable: UITableView!
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.changeFontAndTintColor(to: UIColor.Interface.iDarkBlue)
    }

    // MARK: - Navigation
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: self.segueToEdit, sender: nil)
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}

extension NewContextViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.colorOptions.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = self.colorsCollection.dequeueReusableCell(withReuseIdentifier: self.collectionCellIdentifier, for: indexPath)
		
		cell.backgroundColor = self.viewModel.colorOptions[indexPath.row]
		
		return cell
	}
}

extension NewContextViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.suggestionOptions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.suggestionsTable.dequeueReusableCell(withIdentifier: self.tableCellIdentifier, for: indexPath)
		
		cell.textLabel?.text = self.viewModel.suggestionOptions[indexPath.row]
		
		return cell
	}
}
