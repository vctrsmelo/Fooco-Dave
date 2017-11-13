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
		
		static prefix func ! (value: MovementState) -> MovementState {
			switch value {
			case .atCenter:
				return .atCenter
			
			case .atRight:
				return .atLeft
				
			case .atLeft:
				return .atRight
				
			case .goingRight:
				return .goingLeft
				
			case .goingLeft:
				return .goingRight
			}
		}
	}
	
	// MARK: - Properties

	private var activities = [Activity]()
	
	private let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear)
	
	private var state: MovementState = .atCenter
	
	private var previousActivityViewCenter: CGFloat = 0
	
	private var movement: CGFloat {
		return (self.activityView.bounds.width * 3 / 4).rounded()
	}
	
	// MARK: Outlets

	@IBOutlet private weak var activityCenterConstraint: NSLayoutConstraint!
	@IBOutlet private weak var topLabel: UILabel!
	@IBOutlet private weak var activityView: UIView!
	@IBOutlet private weak var leftView: UIView!
	@IBOutlet private weak var rightView: UIView!
	
	// MARK: - View Handling

	override func viewDidLoad() {
        super.viewDidLoad()
		
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
	
	// MARK: - General Methods

	
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
	
	
	@IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
		
		let translation = sender.translation(in: sender.view)
		let velocity = sender.velocity(in: sender.view)
		
		switch sender.state {
		case .began:
			if velocity.x > 0 && (self.state == .atCenter || self.state == .atLeft) {
				self.moveRight()
				
			} else if velocity.x < 0 && (self.state == .atCenter || self.state == .atRight) {
				self.moveLeft()
			}
			
		case.changed:
			if self.state == .goingRight {
				self.animator.fractionComplete = translation.x / self.movement
				
			} else if self.state == .goingLeft {
				self.animator.fractionComplete = -translation.x / self.movement
			}
			
		case .ended, .cancelled:
			if (self.state == .goingRight && velocity.x <= 0) ||
				(self.state == .goingLeft && velocity.x >= 0) ||
				(self.animator.fractionComplete < 0.3 && abs(velocity.x) < 0) {
				self.animator.isReversed = !self.animator.isReversed
				self.state = !self.state
			}
			
			self.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			
		case .failed, .possible:
			break
		}
	}
	
	// MARK: - Animation
	
	private func showCorrectViews() {
		if self.activityCenterConstraint.constant > 0 {
			self.leftView.alpha = 1
			self.rightView.alpha = 0
		} else if self.activityCenterConstraint.constant < 0 {
			self.leftView.alpha = 0
			self.rightView.alpha = 1
		} else {
			self.leftView.alpha = 0
			self.rightView.alpha = 0
		}
	}
	
	private func moveRight() {
		animator.addAnimations {
			self.previousActivityViewCenter = self.activityCenterConstraint.constant
			self.activityCenterConstraint.constant += self.movement
			self.view.layoutIfNeeded()
			
			self.showCorrectViews()
		}
		
		self.state = .goingRight
		
		self.animationCommon()
	}
	
	private func moveLeft() {
		animator.addAnimations {
			self.previousActivityViewCenter = self.activityCenterConstraint.constant
			self.activityCenterConstraint.constant -= self.movement
			self.view.layoutIfNeeded()
			
			self.showCorrectViews()
		}
		
		self.state = .goingLeft
		
		self.animationCommon()
	}
	
	private func animationCommon() {
		self.animator.addCompletion { position in
			if position == .start {
				self.activityCenterConstraint.constant = self.previousActivityViewCenter
			}
			
			self.switchState()
		}
		self.animator.isInterruptible = true
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
