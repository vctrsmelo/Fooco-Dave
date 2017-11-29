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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
