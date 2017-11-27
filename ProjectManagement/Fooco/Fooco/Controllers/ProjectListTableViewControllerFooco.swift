//
//  ProjectListTableViewControllerFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 26/11/17.
//

import UIKit

class ProjectListTableViewControllerFooco: UITableViewController, EditProjectUnwindOption {
	
	let unwindFromProjectSaving = ""

	var projects = [Project]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.tableView.tableFooterView = UIView() // Makes empty cells not appear
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.projects = User.sharedInstance.projects
		
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
			self.projects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
