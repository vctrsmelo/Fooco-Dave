//
//  EditProjectViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

protocol EditProjectUnwindOption: AnyObject {
	var unwindFromProject: String { get }
}

class EditProjectViewControllerFooco: UIViewController {
	
	var project: Project?
	
	var unwindSegueIdentifier: String = ""
	
	private weak var tableViewController: EditProjectTableViewControllerFooco!
	
	private var viewModel: EditProjectViewModel {
		return self.tableViewController.viewModel
	}
		
    @IBOutlet private weak var datePickerAlertView: DatePickerAlertView!
	
    @IBOutlet private weak var bottomBg1ImageView: UIImageView!
    @IBOutlet private weak var bottomBg2ImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerAlertView.initialSetup()
		
        bottomBg1ImageView.image = bottomBg1ImageView.image!.withRenderingMode(.alwaysTemplate)
        bottomBg2ImageView.image = bottomBg2ImageView.image!.withRenderingMode(.alwaysTemplate)
        bottomBg1ImageView.tintColor = #colorLiteral(red: 72/255, green: 210/255, blue: 160/255, alpha: 0.46)
        bottomBg2ImageView.tintColor = #colorLiteral(red: 72/255, green: 210/255, blue: 160/255, alpha: 0.46)
		
        self.hideKeyboardOnOutsideTap()
    }
    
    // MARK: - Navigation
    
	@IBAction func cancelTapped(_ sender: UIBarButtonItem) {
		self.performSegue(withIdentifier: self.unwindSegueIdentifier, sender: self)
	}
	
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
		if self.viewModel.canSaveProject() {
			self.viewModel.saveProject()
			
			self.performSegue(withIdentifier: self.unwindSegueIdentifier, sender: self)
			
		} else {
			print("Error") // TODO: Tell the user that there is missing information
		}
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectTableViewSegue" {
            let editProjTableViewController = segue.destination as! EditProjectTableViewControllerFooco
			
			self.tableViewController = editProjTableViewController
            editProjTableViewController.delegate = self
			editProjTableViewController.viewModel = EditProjectViewModel(with: self.project)
        }
    }

}

// MARK: - EditProjectTableViewControllerDelegate

extension EditProjectViewControllerFooco: EditProjectTableViewControllerDelegate {
   
	func presentPickerAlert(with pickerAlertViewModel: PickerAlertViewModel) {
		self.datePickerAlertView.present(with: pickerAlertViewModel)
    }
    
    func contextUpdated() {
        let color = self.viewModel.chosenContext?.color ?? .addContextColor
		self.navigationController?.navigationBar.changeFontAndTintColor(to: color)
    }
    
}
