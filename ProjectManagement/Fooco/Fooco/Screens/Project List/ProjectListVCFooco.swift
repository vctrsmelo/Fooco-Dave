//
//  ProjectListVCFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 26/11/17.
//

import UIKit

class ProjectListVCFooco: UIViewController, EditProjectUnwindOption {
	
	let unwindFromProject = "unwindFromEditToProjectList"
	
	private let segueToProject = "fromProjectListToEdit"

	var projects = [Project]()
	
	private var addButton: FloatingAddButton!
	
	@IBOutlet private weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.tableView.tableFooterView = UIView() // Makes empty cells not appear
		
		self.addButton = FloatingAddButton(to: self, inside: self.view, performing: #selector(addButtonTapped))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.projects = User.sharedInstance.projects
		self.tableView.reloadData()
		
		self.navigationController?.navigationBar.removeBackgroundImage()
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		self.tableView.setEditing(editing, animated: animated)
	}
	
	// MARK: - Add Button
	
	@objc
	private func addButtonTapped(sender: UIButton) {
		self.performSegue(withIdentifier: self.segueToProject, sender: nil)
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == self.segueToProject,
			let navigationVC = segue.destination as? UINavigationController,
			let destinationVC = navigationVC.topViewController as? EditProjectVCFooco {
			destinationVC.unwindSegueIdentifier = self.unwindFromProject
			destinationVC.project = sender as? Project
		}
    }
	
	@IBAction func unwindToProjectList(with unwindSegue: UIStoryboardSegue) {
	}

}

// MARK: - Table view data source

extension ProjectListVCFooco: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.projects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: ProjectListCellFooco.identifier, for: indexPath)
		
		if let someCell = cell as? ProjectListCellFooco {
			someCell.project = projects[indexPath.row]
			cell = someCell
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			User.sharedInstance.projects.remove(at: indexPath.row)
			self.projects = User.sharedInstance.projects
			tableView.deleteRows(at: [indexPath], with: .left)
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedProject = self.projects[indexPath.row]
		
		self.performSegue(withIdentifier: self.segueToProject, sender: selectedProject)
	}
}
