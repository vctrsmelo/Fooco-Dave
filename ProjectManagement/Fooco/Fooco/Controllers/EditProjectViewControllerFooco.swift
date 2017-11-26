//
//  EditProjectViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

class EditProjectViewControllerFooco: UIViewController {
	
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet private weak var datePickerAlertView: DatePickerAlertView!
    
    weak var tableView: UITableView!
    weak var contextsCollectionView: UICollectionView!
    
    @IBOutlet private weak var bottomBg1ImageView: UIImageView!
    @IBOutlet private weak var bottomBg2ImageView: UIImageView!
    
    var project: Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerAlertView.initialSetup()
        datePickerAlertView.configure()
        datePickerAlertView.setNeedsLayout()
        
        bottomBg1ImageView.image = bottomBg1ImageView.image!.withRenderingMode(.alwaysTemplate)
        bottomBg2ImageView.image = bottomBg2ImageView.image!.withRenderingMode(.alwaysTemplate)
        bottomBg1ImageView.tintColor = #colorLiteral(red: 72/255, green: 210/255, blue: 160/255, alpha: 0.46)
        bottomBg2ImageView.tintColor = #colorLiteral(red: 72/255, green: 210/255, blue: 160/255, alpha: 0.46)
        
        //delegates and data sources
        formatNavigationBar()
        
        //hide keyboard when view is tapped
        hideKeyboardWhenTappedAround()
        
    }
    
    /**
     Format navigation bar design
    */
    private func formatNavigationBar() {
        
        //TODO: edit here to get the current context selected color
//        guard let mainColor = UIColor.contextColors().first else {
//            return
//        }
        
        navigationBar.removeShadowAndBackgroundImage()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectTableViewSegue" {
            let editProjTableViewController = segue.destination as! EditProjectTableViewControllerFooco
            
            contextsCollectionView = editProjTableViewController.contextsCollectionView
            tableView = editProjTableViewController.tableView
            editProjTableViewController.delegate = self
            datePickerAlertView.delegate = editProjTableViewController
        }
    }
    
    

}

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
