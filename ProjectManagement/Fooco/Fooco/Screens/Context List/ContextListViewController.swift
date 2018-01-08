//
//  ContextListViewController.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 29/11/17.
//

import UIKit

class ContextListViewController: UIViewController {

	private let segueToContext = "fromContextListToAdd"
	
	private var addButton: FloatingAddButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addButton = FloatingAddButton(to: self, inside: self.view, performing: #selector(addButtonTapped))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBar.removeBackgroundImage()
	}
	
	// MARK: - Add Button
	
	@objc
	private func addButtonTapped(sender: UIButton) {
		self.performSegue(withIdentifier: self.segueToContext, sender: nil)
	}

    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
    
    @IBAction func unwindToContextList(with unwindSegue: UIStoryboardSegue) {
    }

}
