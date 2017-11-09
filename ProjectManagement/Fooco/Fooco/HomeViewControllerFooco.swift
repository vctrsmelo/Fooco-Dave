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
	
//	private var centerViewInitialX: CGFloat = 0
//	private var leftViewInitialX: CGFloat = 0
//	private var rightViewInitialX: CGFloat = 0
	
	private var movement: CGFloat {
		return self.leftView.frame.width.rounded() // leftView and rightView should have the same size
	}
	
//	var centerViewRightX: CGFloat {
//		return self.centerViewInitialX + self.movement
//	}
	
//	var centerViewLeftX: CGFloat {
//		return self.centerViewInitialX - self.movement
//	}
	
	@IBOutlet private weak var topLabel: UILabel!
	@IBOutlet private weak var activityView: UIView!
	@IBOutlet private weak var leftView: UIView!
	@IBOutlet private weak var rightView: UIView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
//		self.centerViewInitialX = self.activityView.frame.origin.x
//		self.leftViewInitialX = self.leftView.frame.origin.x
//		self.rightViewInitialX = self.rightView.frame.origin.x
		
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
			
//		case 0..<self.movement:
//			self.state = .goingRight
//
//		case -self.movement..<0:
//			self.state = .goingLeft
			
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
	@IBOutlet weak var activityCenterConstraint: NSLayoutConstraint!
	
	@IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
		
		let translation = sender.translation(in: sender.view)
		let direction = sender.velocity(in: sender.view)
		
		switch sender.state {
		case .began:
			print(translation)
//			print(sender.velocity(in: sender.view))
//			print(self.state)
			if (self.state == .atCenter || self.state == .atLeft) && translation.x > 0 {
				self.moveRight()
			} else if (self.state == .atCenter || self.state == .atRight) && translation.x < 0 {
				self.moveLeft()
			}
			
		case.changed:
			if self.state == .goingRight {
				self.animator.fractionComplete = translation.x / self.movement
			} else if self.state == .goingLeft {
				self.animator.fractionComplete = -translation.x / self.movement
			}
			
		case .ended, .cancelled:
//			if self.animator.fractionComplete < 0.3 {
//				self.animator.isReversed = !self.animator.isReversed
//			}
			self.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			
		case .failed, .possible:
			break
		}
	}
	
	private func moveRight() {
		animator.addAnimations {
			self.activityCenterConstraint.constant += self.movement
			self.view.layoutIfNeeded()
//			self.activityView.frame = self.activityView.frame.offsetBy(dx: self.movement, dy: 0)
			
//			self.leftView.frame.origin.x = self.leftViewInitialX + self.movement
			self.leftView.alpha = 1
			
//			self.rightView.frame.origin.x = self.rightViewInitialX
			self.rightView.alpha = 0
		}
		
		animator.addCompletion { position in
			if position ==  .start {
				self.activityCenterConstraint.constant = 0
			}
		}
		
		self.state = .goingRight
		
		self.animationCommon()
	}
	
	private func moveLeft() {
		animator.addAnimations {
			self.activityCenterConstraint.constant -= self.movement
			self.view.layoutIfNeeded()
//			self.activityView.frame = self.activityView.frame.offsetBy(dx: -self.movement, dy: 0)
			
//			self.leftView.frame.origin.x = self.leftViewInitialX
			self.leftView.alpha = 0
			
//			self.rightView.frame.origin.x = self.rightViewInitialX - self.movement
			self.rightView.alpha = 1
		}
		
		animator.addCompletion { position in
			if position == .start {
				self.activityCenterConstraint.constant = 0
			}
		}
		
		self.state = .goingLeft
		
		self.animationCommon()
	}
	
	private func animationCommon() {
		self.animator.addCompletion { position in
//			if position == .end {
				self.switchState()
//			}
			
			self.view.layoutIfNeeded()
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

extension CGPoint {
	static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}
