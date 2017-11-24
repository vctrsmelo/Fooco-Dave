//
//  MenuTableViewControllerFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 24/11/17.
//

import UIKit

class MenuTableViewControllerFooco: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationController?.navigationBar.removeBackground()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
	}

    // MARK: - Navigation
	
	@IBAction func unwindToMenu(with unwindSegue: UIStoryboardSegue) {
		print(#function)
	}

}
