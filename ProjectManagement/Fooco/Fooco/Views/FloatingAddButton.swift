//
//  FloatingAddButton.swift
//  Fooco
//
//  Created by Rodrigo Cardoso Buske on 22/11/17.
//

import UIKit

class FloatingAddButton: UIButton {
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
		
		self.titleLabel?.text = "+"
		self.titleLabel?.font = self.titleLabel?.font.withSize(50)
		self.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
	}
	
	convenience init(to controller: UIViewController, inside parent: UIView, performing action: Selector) {
		self.init()
		
		parent.addSubview(self)
		
		self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: 18).isActive = true
		self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 11).isActive = true
		
		self.widthAnchor.constraint(equalToConstant: self.frame.width)
		self.heightAnchor.constraint(equalToConstant: self.frame.height)
		
		self.addTarget(controller, action: action, for: .primaryActionTriggered)
	}
}
