//
//  ViewSwiper.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 13/11/17.
//

import UIKit

class ViewSwiper: NSObject {
	
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
		
		static func state(for position: CGFloat) -> MovementState {
			switch position {
			case 0:
				return .atCenter
				
			case 0...:
				return .atRight
				
			case ...0:
				return .atLeft
				
			default:
				fatalError("Should be unreachable")
			}
		}
	}

	// MARK: - Properties
	
	private let centerAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7)
	private let sideAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7)
	private let swipeAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.7)
	
	private var movementState: MovementState = .atCenter
	
	private var previousCenterViewConstraint: CGFloat = 0
	
	private var movement: CGFloat {
		return (self.centerView.bounds.width / 2).rounded()
	}
	
	// MARK: Outlets
	@IBOutlet private weak var controller: UIViewController!
	
	@IBOutlet private weak var centerViewCenterConstraint: NSLayoutConstraint!
	
	@IBOutlet private weak var doneViewHalfWidth: NSLayoutConstraint!
	@IBOutlet private weak var doneViewFullWidth: NSLayoutConstraint!
	
	@IBOutlet private weak var leftViewLeading: NSLayoutConstraint!
	@IBOutlet private weak var leftViewTrailing: NSLayoutConstraint!
	
	@IBOutlet private weak var skipViewHalfWidth: NSLayoutConstraint!
	@IBOutlet private weak var skipViewFullWidth: NSLayoutConstraint!
	
	@IBOutlet private weak var rightViewLeading: NSLayoutConstraint!
	@IBOutlet private weak var rightViewTrailing: NSLayoutConstraint!
	
	@IBOutlet private weak var centerView: UIView!
	@IBOutlet private weak var leftView: UIView!
	@IBOutlet private weak var rightView: UIView!
	
	@IBOutlet private weak var doneView: UIView!
	@IBOutlet private weak var focusView: UIView!
	@IBOutlet private weak var enoughView: UIView!
	@IBOutlet private weak var skipView: UIView!
	
	// MARK: - Init
	
	func load() {
		self.centerAnimator.isInterruptible = true
		self.sideAnimator.isInterruptible = true
		
		self.addPanGestureRecognizer()
		self.addGestureRecognizers()
	}
	
	// MARK: - Gestures
	
	private func tapGestureRecognizer() -> UITapGestureRecognizer {
		return UITapGestureRecognizer(target: self, action: #selector(handleSubviewsTapGesture))
	}
	
	private func panGestureCreator() -> UIPanGestureRecognizer {
		return UIPanGestureRecognizer(target: self, action: #selector(handleSubviewsPanGesture))
	}
	
	private func addGestureRecognizers() {
		self.doneView.addGestureRecognizer(self.tapGestureRecognizer())
		self.doneView.addGestureRecognizer(self.panGestureCreator())
		
		self.focusView.addGestureRecognizer(self.tapGestureRecognizer())
		self.focusView.addGestureRecognizer(self.panGestureCreator())
		
		self.enoughView.addGestureRecognizer(self.tapGestureRecognizer())
		self.enoughView.addGestureRecognizer(self.panGestureCreator())
		
		self.skipView.addGestureRecognizer(self.tapGestureRecognizer())
		self.skipView.addGestureRecognizer(self.panGestureCreator())
	}
	
	private func addPanGestureRecognizer() {
		self.centerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
	}
	
	@objc
	private func handleSubviewsTapGesture(_ sender: UITapGestureRecognizer) {
		switch sender.view! {
		case self.doneView:
			self.doneViewAnimation()
			self.sideAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		
		case self.focusView:
			break
			
		case self.enoughView:
			break
			
		case self.skipView:
			self.skipViewAnimation()
			self.sideAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		
		default:
			break
		}
	}
	
	@objc
	private func handleSubviewsPanGesture(_ sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: sender.view)
		
		switch (sender.state, sender.view!) {
		case (.began, self.doneView), (.began, self.focusView):
			self.doneViewAnimation()
			
		case (.began, self.skipView), (.began, self.enoughView):
			self.skipViewAnimation()
		
		case (.changed, self.doneView), (.changed, self.focusView):
			self.sideAnimator.fractionComplete = translation.x * 2 / self.controller.view.frame.maxX
			
		case (.changed, self.skipView), (.changed, self.enoughView):
			self.sideAnimator.fractionComplete = -translation.x * 2 / self.controller.view.frame.maxX
			
		case (.ended, _), (.cancelled, _):
			if self.sideAnimator.fractionComplete <= 0.3 {
				self.sideAnimator.isReversed = !self.sideAnimator.isReversed
			}
			
			self.sideAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			
		default:
			break
		}
	}
	
	@objc
	private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: sender.view)
		let velocity = sender.velocity(in: sender.view)
		
		switch sender.state {
		case .began:
			if velocity.x > 0 && (self.movementState == .atCenter || self.movementState == .atLeft) {
				self.moveRight()
				
			} else if velocity.x < 0 && (self.movementState == .atCenter || self.movementState == .atRight) {
				self.moveLeft()
			}
			
		case.changed:
			if self.movementState == .goingRight {
				self.centerAnimator.fractionComplete = translation.x / self.movement
			
			} else if self.movementState == .goingLeft {
				self.centerAnimator.fractionComplete = -translation.x / self.movement
			}
			
		case .ended, .cancelled:
			if (self.movementState == .goingRight && velocity.x <= 0) ||
				(self.movementState == .goingLeft && velocity.x >= 0) ||
				(self.centerAnimator.fractionComplete < 0.3 && abs(velocity.x) < 0) {
				self.centerAnimator.isReversed = !self.centerAnimator.isReversed
				self.movementState = !self.movementState
			}
			
			self.centerAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			
		case .failed, .possible:
			break
		}
	}
	
	// MARK: - Animation
	
	private func showCorrectViews() {
		if self.centerViewCenterConstraint.constant > 0 {
			self.leftView.alpha = 1
			self.rightView.alpha = 0
		} else if self.centerViewCenterConstraint.constant < 0 {
			self.leftView.alpha = 0
			self.rightView.alpha = 1
		} else {
			self.leftView.alpha = 0
			self.rightView.alpha = 0
		}
	}
	
	private func moveRight() {
		self.centerAnimator.addAnimations {
			self.previousCenterViewConstraint = self.centerViewCenterConstraint.constant
			self.centerViewCenterConstraint.constant += self.movement
			self.controller.view.layoutIfNeeded()
			
			self.showCorrectViews()
		}
		
		self.movementState = .goingRight
		
		self.animationCommon()
	}
	
	private func moveLeft() {
		self.centerAnimator.addAnimations {
			self.previousCenterViewConstraint = self.centerViewCenterConstraint.constant
			self.centerViewCenterConstraint.constant -= self.movement
			self.controller.view.layoutIfNeeded()
			
			self.showCorrectViews()
		}
		
		self.movementState = .goingLeft
		
		self.animationCommon()
	}
	
	private func animationCommon() {
		self.centerAnimator.addCompletion { position in
			if position == .start {
				self.centerViewCenterConstraint.constant = self.previousCenterViewConstraint
			}
			
			self.movementState = MovementState.state(for: self.centerViewCenterConstraint.constant)
		}
		
		self.centerAnimator.pauseAnimation()
	}
	
	private func doneViewWidthSwitch() {
		self.doneViewHalfWidth.isActive = !self.doneViewHalfWidth.isActive
		self.doneViewFullWidth.isActive = !self.doneViewFullWidth.isActive
	}
	
	private func doneViewAnimation() {
		self.sideAnimator.addAnimations {
			self.doneViewWidthSwitch()
		}
		
		self.sideAnimator.addAnimations {
			self.previousCenterViewConstraint = self.centerViewCenterConstraint.constant
			self.centerViewCenterConstraint.constant = self.controller.view.frame.maxX
			
			self.leftViewTrailing.isActive = true

			self.controller.view.layoutIfNeeded()
		}
		
		self.sideAnimator.addCompletion { position in
			if position == .start {
				self.centerViewCenterConstraint.constant = self.previousCenterViewConstraint
				
				self.leftViewTrailing.isActive = false
				
				self.doneViewWidthSwitch()
				
			} else if position == .end {
				self.cardFromLeftAnimation()
			}
		}
		
		self.sideAnimator.pauseAnimation()
	}
	
	private func cardFromLeftAnimation() {
		self.centerViewCenterConstraint.constant = -self.controller.view.frame.maxX
		self.controller.view.layoutIfNeeded()
		
		self.swipeAnimator.addAnimations {
			self.centerViewCenterConstraint.constant = 0
			
			self.showCorrectViews()
			
			self.leftViewLeading.isActive = false
			
			self.controller.view.layoutIfNeeded()
		}
		
		self.swipeAnimator.addCompletion { _ in
			self.leftViewLeading.isActive = true
			self.leftViewTrailing.isActive = false
			
			self.doneViewWidthSwitch()
			
			self.movementState = MovementState.state(for: self.centerViewCenterConstraint.constant)
		}
		
		self.swipeAnimator.startAnimation()
	}
	
	private func skipViewWidthSwitch() {
		self.skipViewHalfWidth.isActive = !self.skipViewHalfWidth.isActive
		self.skipViewFullWidth.isActive = !self.skipViewFullWidth.isActive
	}
	
	private func skipViewAnimation() {
		self.sideAnimator.addAnimations {
			self.skipViewWidthSwitch()
		}
		
		self.sideAnimator.addAnimations {
			self.previousCenterViewConstraint = self.centerViewCenterConstraint.constant
			self.centerViewCenterConstraint.constant = -self.controller.view.frame.maxX
			
			self.rightViewLeading.isActive = true
			
			self.controller.view.layoutIfNeeded()
		}
		
		self.sideAnimator.addCompletion { position in
			if position == .start {
				self.centerViewCenterConstraint.constant = self.previousCenterViewConstraint
				
				self.rightViewLeading.isActive = false
				
				self.skipViewWidthSwitch()
				
			} else if position == .end {
				self.cardFromRightAnimation()
			}
		}
		
		self.sideAnimator.pauseAnimation()
	}
	
	private func cardFromRightAnimation() {
		self.centerViewCenterConstraint.constant = self.controller.view.frame.maxX
		self.controller.view.layoutIfNeeded()
		
		self.swipeAnimator.addAnimations {
			self.centerViewCenterConstraint.constant = 0
			
			self.showCorrectViews()
			
			self.rightViewTrailing.isActive = false
			
			self.controller.view.layoutIfNeeded()
		}
		
		self.swipeAnimator.addCompletion { _ in
			self.rightViewTrailing.isActive = true
			self.rightViewLeading.isActive = false
			
			self.skipViewWidthSwitch()
			
			self.movementState = MovementState.state(for: self.centerViewCenterConstraint.constant)
		}
		
		self.swipeAnimator.startAnimation()
	}
	
}
