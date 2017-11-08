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
	
//	private var goingLeft = false
//	private var goingRight = false
	
	private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut)
	
	private var movementState = MovementState.atCenter
	private var movement: CGFloat = 0
	
	private var initialCenterPosition: CGPoint = CGPoint.zero
	private var initialLeftPosition: CGPoint = CGPoint.zero
	private var initialRightPosition: CGPoint = CGPoint.zero
	
	@IBOutlet private weak var topLabel: UILabel!
	@IBOutlet private weak var activityView: UIView!
	@IBOutlet private weak var leftView: UIView!
	@IBOutlet private weak var rightView: UIView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.movement = self.leftView.frame.width // leftView and rightView should have the same size
		
		self.initialCenterPosition = self.activityView.frame.origin
		self.initialLeftPosition = self.leftView.frame.origin
		self.initialRightPosition = self.rightView.frame.origin
		
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

	@IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
		
		let translation = sender.translation(in: self.view)
		
		switch sender.state {
		case .began:
			if (self.movementState == .atCenter || self.movementState == .atLeft) && translation.x > 0 {
				self.moveRight()
			} else if (self.movementState == .atCenter || self.movementState == .atRight) && translation.x < 0 {
				self.moveLeft()
			}
			
		case.changed:
			if self.movementState == .goingRight {
				animator.fractionComplete = translation.x / self.movement
			} else if self.movementState == .goingLeft {
				animator.fractionComplete = -translation.x / self.movement
			}
			
		case .ended, .cancelled:
			animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			
		case .failed, .possible:
			break
		}
	}
	
	private func moveRight() {
		animator.addAnimations {
			self.activityView.frame = self.activityView.frame.offsetBy(dx: self.movement, dy: 0)
			
			self.leftView.frame.origin = self.initialLeftPosition + CGPoint(x: self.movement, y: 0)
			self.leftView.alpha = 1
			
			self.rightView.frame.origin = self.initialRightPosition
			self.rightView.alpha = 0
		}
		
		self.movementState = .goingRight
		
		self.animationCommon()
	}
	
	private func moveLeft() {
		animator.addAnimations {
			self.activityView.frame = self.activityView.frame.offsetBy(dx: -self.movement, dy: 0)
			
			self.leftView.frame.origin = self.initialLeftPosition
			self.leftView.alpha = 0
			
			self.rightView.frame.origin = self.initialRightPosition + CGPoint(x: -self.movement, y: 0)
			self.rightView.alpha = 1
		}
		
		self.movementState = .goingLeft
		
		self.animationCommon()
	}
	
	private func animationCommon() {
		animator.addCompletion { animatingPosition in
			if self.activityView.frame.origin.x == self.initialCenterPosition.x {
				self.movementState = .atCenter
			} else if self.activityView.frame.origin.x > self.initialCenterPosition.x {
				self.movementState = .atRight
			} else if self.activityView.frame.origin.x < self.initialCenterPosition.x {
				self.movementState = .atLeft
			}
		}
		
		animator.pauseAnimation()
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

extension CGPoint {
	static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}
