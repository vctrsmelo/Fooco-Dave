//
//  HomeViewControllerFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 06/11/17.
//

import UIKit

class HomeViewControllerFooco: UIViewController {
	
	// MARK: - Properties

	private var activities = [Activity]()
	
	private var addButton: FloatingAddButton!
	
	// MARK: Outlets
	@IBOutlet private weak var viewSwiper: ViewSwiper!
	@IBOutlet private weak var topLabel: UILabel!
	
	// MARK: - View Handling

	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.viewSwiper.load()
		
		self.addButton = FloatingAddButton(to: self, inside: self.view, performing: #selector(addButtonTapped))
		
		self.navigationItem.title = self.chooseGreeting(for: Date())
		
		self.topLabel.text = self.chooseTopLabelText()		
    }
	
	private func chooseTopLabelText() -> String {
		let topLabelText: String
		
		if self.activities.isEmpty {
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
	
	@objc
	private func addButtonTapped(sender: UIButton) {
		print(#function)
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
