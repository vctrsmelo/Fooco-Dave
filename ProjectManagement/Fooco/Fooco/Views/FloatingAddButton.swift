//
//  FloatingAddButton.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 22/11/17.
//

import UIKit

class FloatingAddButton: UIButton {
	override var isHighlighted: Bool {
		didSet {
			self.backgroundColor = self.isHighlighted ? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		}
	}
	
	private let defaultSize = 50
	
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: self.defaultSize, height: self.defaultSize))
		
		self.initializer()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.initializer()
	}
	
	private func initializer() {
		self.cornerRadius = self.frame.width / 2
		
		self.setTitle("+", for: .normal)
		self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
		self.titleLabel?.font = self.titleLabel?.font.withSize(50)
		self.titleLabel?.textAlignment = .center
		
		self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		
		self.titleEdgeInsets.bottom = 8
	}
	
	convenience init(to controller: UIViewController, inside parent: UIView, performing action: Selector) {
		self.init()
		
		parent.addSubview(self)
		
		self.translatesAutoresizingMaskIntoConstraints = false
		
		self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -18).isActive = true
		self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -11).isActive = true
		
		self.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
		self.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
		
		self.addTarget(controller, action: action, for: .primaryActionTriggered)
	}
}
