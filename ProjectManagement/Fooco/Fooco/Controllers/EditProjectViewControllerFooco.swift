//
//  EditProjectViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

class EditProjectViewControllerFooco: UIViewController {
	
	var project: Project? {
		didSet {
			self.tableViewController?.project = self.project
		}
	}
	
	weak var tableViewController: EditProjectTableViewControllerFooco?
	
	private let unwindFromEditToHomeSaving = "unwindFromEditToHomeSaving"
	
    @IBOutlet private weak var navigationBar: UINavigationBar!
	
    @IBOutlet private weak var datePickerAlertView: DatePickerAlertView!
	
    @IBOutlet private weak var bottomBg1ImageView: UIImageView!
    @IBOutlet private weak var bottomBg2ImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerAlertView.initialSetup()
        datePickerAlertView.configure()
        datePickerAlertView.setNeedsLayout()
        
        bottomBg1ImageView.image = bottomBg1ImageView.image!.withRenderingMode(.alwaysTemplate)
        bottomBg2ImageView.image = bottomBg2ImageView.image!.withRenderingMode(.alwaysTemplate)
        bottomBg1ImageView.tintColor = #colorLiteral(red: 72/255, green: 210/255, blue: 160/255, alpha: 0.46)
        bottomBg2ImageView.tintColor = #colorLiteral(red: 72/255, green: 210/255, blue: 160/255, alpha: 0.46)
        
        // delegates and data sources
        formatNavigationBar()
        
        // hide keyboard when view is tapped
        hideKeyboardWhenTappedAround()
    }
    
    /**
     Format navigation bar design
    */
    private func formatNavigationBar() {
        navigationBar.removeShadowAndBackgroundImage()
    }
	
	@IBAction func saveProject(_ sender: UIBarButtonItem) {
		if let savedProject = self.tableViewController?.saveProject() {
			if self.project === savedProject { // Is editing Project
				let index = User.sharedInstance.projects.index(of: savedProject) // TODO: Give id to projects and make this better
				User.sharedInstance.projects[index!] = savedProject
				
			} else { // Is creating Project
				User.sharedInstance.add(projects: [savedProject])
			}
			
			User.sharedInstance.isCurrentScheduleUpdated = false
			
			self.performSegue(withIdentifier: self.unwindFromEditToHomeSaving, sender: self)
			
		} else {
			print("Error saving") // TODO: Tell the user that there is missing information etc...
		}
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectTableViewSegue" {
            let editProjTableViewController = segue.destination as! EditProjectTableViewControllerFooco
			
			self.tableViewController = editProjTableViewController
            editProjTableViewController.delegate = self
            datePickerAlertView.delegate = editProjTableViewController
        }
    }

}

// MARK: - EditProjectTableViewControllerDelegate

extension EditProjectViewControllerFooco: EditProjectTableViewControllerDelegate {
   
    func estimatedHoursTouched(_ alertView: ((DatePickerAlertView) -> Void)) {
        alertView(datePickerAlertView)
    }
    
    func startingDateTouched(_ alertView: ((DatePickerAlertView) -> Void)) {
        alertView(datePickerAlertView)
    }
    
    func deadlineDateTouched(_ alertView: ((DatePickerAlertView) -> Void)) {
        alertView(datePickerAlertView)
    }
    
    func contextUpdated(for context: Context?) {
        let color = (context != nil) ? context!.color : UIColor.colorOfAddContext()
		self.navigationBar.changeFontAndTintColor(to: color)
    }
    
}
