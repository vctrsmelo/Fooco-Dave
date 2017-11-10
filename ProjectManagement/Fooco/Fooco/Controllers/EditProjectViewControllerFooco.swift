//
//  EditProjectViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit
import Foundation

class EditProjectViewControllerFooco: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var editProjectContainerView: EditProjectContainerView!
    weak var tableView: UITableView!
    weak var contextsCollectionView: UICollectionView!
    
    
    var project: Project?
    
    override func viewDidLoad() {

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

        }
    }

}
