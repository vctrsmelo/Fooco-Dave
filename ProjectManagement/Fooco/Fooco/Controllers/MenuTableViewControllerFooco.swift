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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.navigationBar.changeFontAndTintColor(to: .black)
		self.navigationController?.navigationBar.barStyle = .default
	}

    // MARK: - Navigation
	
	@IBAction func unwindToMenu(with unwindSegue: UIStoryboardSegue) {
		
	}

}
