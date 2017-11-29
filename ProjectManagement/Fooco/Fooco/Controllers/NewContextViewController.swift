//
//  NewContextViewController.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 29/11/17.
//

import UIKit

class NewContextViewController: UIViewController {

    private let segueToEdit = "fromNewContextToEdit"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.changeFontAndTintColor(to: UIColor.InterfaceColors.darkBlue)
    }
    

    // MARK: - Navigation
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: self.segueToEdit, sender: nil)
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}
