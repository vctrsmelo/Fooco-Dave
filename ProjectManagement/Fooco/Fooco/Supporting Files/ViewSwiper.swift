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
	
	private let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.7)
	
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
	
	@IBOutlet private weak var skipViewHalfWidth: NSLayoutConstraint!
	@IBOutlet private weak var skipViewFullWidth: NSLayoutConstraint!
	
	@IBOutlet private weak var centerView: UIView!
	@IBOutlet private weak var leftView: UIView!
	@IBOutlet private weak var rightView: UIView!
	
	@IBOutlet private weak var doneView: UIView!
	@IBOutlet private weak var focusView: UIView!
	@IBOutlet private weak var enoughView: UIView!
	@IBOutlet private weak var skipView: UIView!
	
	// MARK: - Init
	
	func load() {
		self.animator.isInterruptible = true
		
		self.addPanGestureRecognizer()
		self.addPanGestureRecognizers()
	}
	
	// MARK: - Gestures
	
	private func panGestureCreator() -> UIPanGestureRecognizer {
		return UIPanGestureRecognizer(target: self, action: #selector(handleSubviewsPanGesture))
	}
	
	private func addPanGestureRecognizers() {
		self.doneView.addGestureRecognizer(self.panGestureCreator())
		self.focusView.addGestureRecognizer(self.panGestureCreator())
		self.enoughView.addGestureRecognizer(self.panGestureCreator())
		self.skipView.addGestureRecognizer(self.panGestureCreator())
	}
	
	private func addPanGestureRecognizer() {
		self.centerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
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
			self.animator.fractionComplete = translation.x * 2 / self.controller.view.frame.maxX
			
		case (.changed, self.skipView), (.changed, self.enoughView):
			self.animator.fractionComplete = -translation.x * 2 / self.controller.view.frame.maxX
			
		case (.ended, _), (.cancelled, _):
			if self.animator.fractionComplete <= 0.3 {
				self.animator.isReversed = !self.animator.isReversed
			}
			
			self.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			
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
				self.animator.fractionComplete = translation.x / self.movement
				
			} else if self.movementState == .goingLeft {
				self.animator.fractionComplete = -translation.x / self.movement
			}
			
		case .ended, .cancelled:
			if (self.movementState == .goingRight && velocity.x <= 0) ||
				(self.movementState == .goingLeft && velocity.x >= 0) ||
				(self.animator.fractionComplete < 0.3 && abs(velocity.x) < 0) {
				self.animator.isReversed = !self.animator.isReversed
				self.movementState = !self.movementState
			}
			
			self.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			
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
		self.animator.addAnimations {
			self.previousCenterViewConstraint = self.centerViewCenterConstraint.constant
			self.centerViewCenterConstraint.constant += self.movement
			self.controller.view.layoutIfNeeded()
			
			self.showCorrectViews()
		}
		
		self.movementState = .goingRight
		
		self.animationCommon()
	}
	
	private func moveLeft() {
		self.animator.addAnimations {
			self.previousCenterViewConstraint = self.centerViewCenterConstraint.constant
			self.centerViewCenterConstraint.constant -= self.movement
			self.controller.view.layoutIfNeeded()
			
			self.showCorrectViews()
		}
		
		self.movementState = .goingLeft
		
		self.animationCommon()
	}
	
	private func animationCommon() {
		self.animator.addCompletion { position in
			if position == .start {
				self.centerViewCenterConstraint.constant = self.previousCenterViewConstraint
			}
			
			self.movementState = MovementState.state(for: self.centerViewCenterConstraint.constant)
		}
		
		self.animator.pauseAnimation()
	}
	
	private func doneViewAnimation() {
		self.animator.addAnimations {
			self.doneViewHalfWidth.isActive = false
			self.doneViewFullWidth.isActive = true
		}
		
		self.animator.addAnimations {
			self.previousCenterViewConstraint = self.centerViewCenterConstraint.constant
			self.centerViewCenterConstraint.constant = self.controller.view.frame.maxX
			
			self.controller.view.layoutIfNeeded()
		}
		
		self.animator.addCompletion { position in
			if position == .start {
				self.centerViewCenterConstraint.constant = self.previousCenterViewConstraint
				
				self.doneViewFullWidth.isActive = false
				self.doneViewHalfWidth.isActive = true
			}
		}
		
		self.animator.pauseAnimation()
	}
	
	private func skipViewAnimation() {
		self.animator.addAnimations {
			self.skipViewHalfWidth.isActive = false
			self.skipViewFullWidth.isActive = true
		}
		
		self.animator.addAnimations {
			self.previousCenterViewConstraint = self.centerViewCenterConstraint.constant
			self.centerViewCenterConstraint.constant = -self.controller.view.frame.maxX
			
			self.controller.view.layoutIfNeeded()
		}
		
		self.animator.addCompletion { position in
			if position == .start {
				self.centerViewCenterConstraint.constant = self.previousCenterViewConstraint
				
				self.skipViewFullWidth.isActive = false
				self.skipViewHalfWidth.isActive = true
			}
		}
		
		self.animator.pauseAnimation()
	}
	
}
