//
//  EditProjectVCFooco.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

protocol EditProjectUnwindOption: AnyObject {
	var unwindFromProject: String { get }
}

class EditProjectVCFooco: UIViewController {
	
	var project: Project?
	
	var unwindSegueIdentifier: String = ""
	
	private weak var tableViewController: EditProjectTableVCFooco!
	
	private var viewModel: EditProjectVMFooco {
		return self.tableViewController.viewModel
	}
		
    @IBOutlet private weak var pickerAlertView: PickerAlertView!
	
    @IBOutlet private weak var bottomBg1ImageView: UIImageView!
    @IBOutlet private weak var bottomBg2ImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerAlertView.initialSetup()
		
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
			print("[Error] Missing information") // TODO: Tell the user that there is missing information
		}
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectTableViewSegue" {
            let editProjTableViewController = segue.destination as! EditProjectTableVCFooco
			
			self.tableViewController = editProjTableViewController
            editProjTableViewController.delegate = self
			editProjTableViewController.viewModel = EditProjectVMFooco(with: self.project, and: editProjTableViewController)
        }
    }

}

// MARK: - EditProjectTableVCDelegate

extension EditProjectVCFooco: EditProjectTableVCDelegate {
   
	func presentPickerAlert(with pickerAlertViewModel: PickerAlertVM) {
		self.pickerAlertView.present(with: pickerAlertViewModel)
    }
    
    func contextUpdated() {
        let color = self.viewModel.chosenContext?.color ?? .addContextColor
		self.navigationController?.navigationBar.changeFontAndTintColor(to: color)
    }
    
}
