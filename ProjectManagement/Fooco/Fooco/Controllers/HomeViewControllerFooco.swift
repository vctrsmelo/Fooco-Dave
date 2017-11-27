//
//  HomeViewControllerFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 06/11/17.
//

import UIKit

class HomeViewControllerFooco: UIViewController, ViewSwiperDelegate, EditProjectUnwindOption {
	
	// MARK: - Properties
	
	let unwindFromProjectSaving = "unwindFromEditToHomeSaving"

	private var currentActivity: Activity? {
		didSet {
			self.activityCard.data = self.currentActivity
		}
	}
	
	private var projectToEdit: Project?
	
	private var addButton: FloatingAddButton!
	
	private let segueFromHomeToEdit = "fromHomeToEdit"
	
	// MARK: Outlets
	@IBOutlet private weak var viewSwiper: ViewSwiper!
	@IBOutlet private weak var topLabel: UILabel!
	@IBOutlet private weak var activityCard: ActivityCardView!
	
	// MARK: - View Handling

	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.viewSwiper.load()
		self.viewSwiper.delegate = self
		
		self.addButton = FloatingAddButton(to: self, inside: self.view, performing: #selector(addButtonTapped))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.dataUpdate()
		
		self.navigationController?.navigationBar.changeFontAndTintColor(to: .white)
		self.navigationController?.navigationBar.barStyle = .black
	}
	
	private func dataUpdate() {
		User.sharedInstance.updateCurrentScheduleUntil(date: Date().addingTimeInterval(2.days))
		
		self.currentActivity = User.sharedInstance.getNextActivity()
		
		self.navigationItem.title = self.chooseGreeting(for: Date())
		
		self.topLabel.text = self.chooseTopLabelText()
	}
	
	private func chooseTopLabelText() -> String {
		let topLabelText: String
		
		if self.currentActivity == nil {
			topLabelText = NSLocalizedString("You Have Finished for Now", comment: "Home screen top label for empty activities queue")
		} else {
			topLabelText = NSLocalizedString("Your Next Activity", comment: "Home screen default top label")
		}
		
		return topLabelText
	}
	
	private func chooseGreeting(for time: Date) -> String {
		let hour = Calendar.current.component(.hour, from: time)
		
		let greeting: String
		
		switch hour {
		case 12...17:
			greeting = NSLocalizedString("Good Afternoon", comment: "Greeting for afternoon")
			
		case 18...23:
			greeting = NSLocalizedString("Good Evening", comment: "Greeting for evening")
			
		default:
			greeting = NSLocalizedString("Good Morning", comment: "Greeting for morning")
		}
		
		return greeting
	}
	
	// MARK: - Add Button
	
	@objc
	private func addButtonTapped(sender: UIButton) {
		self.projectToEdit = nil
		self.performSegue(withIdentifier: self.segueFromHomeToEdit, sender: self)
	}
	
	// MARK: - ViewSwiperDelegate
	
	func doneExecuted() {
		User.sharedInstance.getNextActivity()?.done = true
		self.dataUpdate()
	}
	
	func focusExecuted() {
		print(#function)
	}
	
	func enoughExecuted() {
		print(#function)
	}
	
	func skipExecuted() {
		print(#function)
	}
	
    // MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == self.segueFromHomeToEdit, let destinationVC = segue.destination as? EditProjectViewControllerFooco {
			destinationVC.unwindSegueIdentifier = self.unwindFromProjectSaving
			destinationVC.project = self.projectToEdit // Is set to nil if it's supposed to add
		}
	}

	@IBAction func unwindToHome(with unwindSegue: UIStoryboardSegue) {
		if unwindSegue.identifier == self.unwindFromProjectSaving {
			self.dataUpdate()
		}
	}

}
