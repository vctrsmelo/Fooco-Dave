//
//  HomeViewControllerFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 06/11/17.
//

import UIKit

class HomeViewControllerFooco: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var activityView: UIView!
	@IBOutlet weak var leftView: UIView!
	@IBOutlet weak var rightView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.title = self.chooseGreeting(for: Date())
		
		self.topLabel.text = NSLocalizedString("Your Next Activity", comment: "Home screen top label")

        self.scrollView.delegate = self
    }
	
	private func chooseGreeting(for time: Date) -> String {
		let hour = Calendar.current.component(.hour, from: time)
		
		let greeting: String
		
		switch hour {
		case 12...17:
			greeting = NSLocalizedString("Good Afternoon", comment: "Greeting")
			
		case 18...23:
			greeting = NSLocalizedString("Good Evening", comment: "Greeting")
			
		default:
			greeting = NSLocalizedString("Good Morning", comment: "Greeting")
		}
		
		return greeting
	}
	
	// MARK: - Scroll View Delegate
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		print(scrollView.contentOffset)
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
