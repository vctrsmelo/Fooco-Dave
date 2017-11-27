//
//  ProjectListTableViewControllerFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 26/11/17.
//

import UIKit

class ProjectListTableViewControllerFooco: UITableViewController, EditProjectUnwindOption {
	
	let unwindFromProject = "unwindFromEditToProjectList"
	
	private let segueToEdit = "fromProjectListToEdit"

	var projects = [Project]()
	
	private var selectedProject: Project?
	
	private var addButton: FloatingAddButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.tableView.tableFooterView = UIView() // Makes empty cells not appear
		
		self.addButton = FloatingAddButton(to: self, inside: self.view, performing: #selector(addButtonTapped)) // TODO: Not working, probably because it's a UITableViewController
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.projects = User.sharedInstance.projects
		self.tableView.reloadData()
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(from: .white), for: .default)
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ProjectListTableViewCell.identifier, for: indexPath)

		if let someCell = cell as? ProjectListTableViewCell {
			someCell.project = projects[indexPath.row]
			cell = someCell
		}

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			User.sharedInstance.projects.remove(at: indexPath.row)
			self.projects = User.sharedInstance.projects
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedProject = self.projects[indexPath.row]
		
		self.performSegue(withIdentifier: self.segueToEdit, sender: self)
	}
	
	// MARK: - Add Button
	
	@objc
	private func addButtonTapped(sender: UIButton) {
		self.selectedProject = nil
		self.performSegue(withIdentifier: self.segueToEdit, sender: self)
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == self.segueToEdit,
			let navigationVC = segue.destination as? UINavigationController,
			let destinationVC = navigationVC.topViewController as? EditProjectViewControllerFooco {
			destinationVC.unwindSegueIdentifier = self.unwindFromProject
			destinationVC.project = self.selectedProject
		}
    }
	
	@IBAction func unwindToProjectList(with unwindSegue: UIStoryboardSegue) {
	}

}
