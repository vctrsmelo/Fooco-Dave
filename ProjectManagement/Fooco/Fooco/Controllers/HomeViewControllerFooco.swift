//
//  HomeViewControllerFooco.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 06/11/17.
//

import UIKit

class HomeViewControllerFooco: UIViewController {

	private enum MovementState {
		case atCenter, atRight, atLeft, goingRight, goingLeft
	}
	
	private var activities = [Activity]()
	
	private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut)
	
	private var state: MovementState = .atCenter {
		didSet {
			print("old")
			print(oldValue)
			print("new")
			print(state)
		}
	}
	
	private var movement: CGFloat {
		return self.leftView.frame.width.rounded() // leftView and rightView should have the same size
	}
	
	@IBOutlet private weak var activityCenterConstraint: NSLayoutConstraint!
	@IBOutlet private weak var topLabel: UILabel!
	@IBOutlet private weak var activityView: UIView!
	@IBOutlet private weak var leftView: UIView!
	@IBOutlet private weak var rightView: UIView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.title = self.chooseGreeting(for: Date())
		
		self.topLabel.text = self.chooseTopLabelText()
    }
	
	private func switchState() {
		switch self.activityCenterConstraint.constant {
		case 0:
			self.state = .atCenter
			
		case 0...:
			self.state = .atRight
			
		case ...0:
			self.state = .atLeft
			
		default:
			fatalError("Should be unreachable")
		}
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
	
	@IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
		
		let translation = sender.translation(in: sender.view)
		let direction = sender.velocity(in: sender.view)
		
		switch sender.state {
		case .began:
			if (self.state == .atCenter || self.state == .atLeft) && direction.x > 0 {
				self.moveRight()
			} else if (self.state == .atCenter || self.state == .atRight) && direction.x < 0 {
				self.moveLeft()
			}
			
		case.changed:
			if self.state == .goingRight {
				self.animator.fractionComplete = translation.x / self.movement
			} else if self.state == .goingLeft {
				self.animator.fractionComplete = -translation.x / self.movement
			}
			
		case .ended, .cancelled:
			self.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			
		case .failed, .possible:
			break
		}
	}
	
	private func moveRight() {
		animator.addAnimations {
			self.activityCenterConstraint.constant += self.movement
			self.view.layoutIfNeeded()

			self.leftView.alpha = 1
			self.rightView.alpha = 0
		}
		
		self.state = .goingRight
		
		self.animationCommon()
	}
	
	private func moveLeft() {
		animator.addAnimations {
			self.activityCenterConstraint.constant -= self.movement
			self.view.layoutIfNeeded()
			
			self.leftView.alpha = 0
			self.rightView.alpha = 1
		}
		
		self.state = .goingLeft
		
		self.animationCommon()
	}
	
	private func animationCommon() {
		self.animator.addCompletion { position in
			if position == .end {
				self.switchState()
			}
		}
		
		self.animator.pauseAnimation()
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
