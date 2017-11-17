//
//  EditProjectViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit
import Foundation

class EditProjectViewControllerFooco: UIViewController, EditProjectContextUpdated {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var datePickerAlertView: DatePickerAlertView!
    
    @IBOutlet weak var editProjectContainerView: EditProjectContainerView!
    weak var tableView: UITableView!
    weak var contextsCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomBg1ImageView: UIImageView!
    @IBOutlet weak var bottomBg2ImageView: UIImageView!
    
    var project: Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerAlertView.initialSetup()
        datePickerAlertView.isTime = false
        datePickerAlertView.setNeedsLayout()
        
        
        bottomBg1ImageView.image = bottomBg1ImageView.image!.withRenderingMode(.alwaysTemplate)
        bottomBg2ImageView.image = bottomBg2ImageView.image!.withRenderingMode(.alwaysTemplate)
        //delegates and data sources
        formatNavigationBar()
        
    }
    
    /**
     Format navigation bar design
    */
    private func formatNavigationBar() {
        
        //TODO: edit here to get the current context selected color
        guard let mainColor = UIColor.contextColors().first else {
            return
        }
        
        navigationBar.removeBackground()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectTableViewSegue" {
            let editProjTableViewController = segue.destination as! EditProjectTableViewController
            
            contextsCollectionView = editProjTableViewController.contextsCollectionView
            tableView = editProjTableViewController.tableView
            editProjTableViewController.delegate = self

        }
    }
    
    func contextUpdated(for context: Context?) {

        let color = (context != nil) ? context!.color : UIColor.colorOfAddContext()
        cancelBarButton.tintColor = color
        bottomBg1ImageView.tintColor = color.withAlphaComponent(0.46)
        bottomBg2ImageView.tintColor = color.withAlphaComponent(0.36)
   
        
    }

}
