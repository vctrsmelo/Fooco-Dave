//
//  EditProjectContextCellFooco.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

class EditProjectContextCellFooco: UICollectionViewCell {
    
    var icon: UIImage!
    
    @IBOutlet private weak var mainBackground: UIView!
    @IBOutlet private weak var shadowLayer: UIView!
    
	static let originalSize = CGSize(width: 150, height: 100)
    private let heightIncreaseFactor: CGFloat = 40.0
    private var featuredPercentage: CGFloat?
	
    private var _context: Context!
    var context: Context! {
        set {
            _context = newValue
            updatedContext()
        }
        get {
            return _context
        }
    }
    
    @IBOutlet private weak var iconImageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    
	func updateSize(cellFrame: CGRect, container: CGRect) {
        
        let originalSize = EditProjectContextCellFooco.originalSize
        
        let containerXCenter: CGFloat = container.origin.x + container.width / 2
        
        let cellXCenter: CGFloat = cellFrame.origin.x + cellFrame.width / 2
        
        let distance: CGFloat = abs(containerXCenter - cellXCenter)
		
        //entre 0 e 100, sendo 100 = maior tamanho e 0 = menor tamanho
        featuredPercentage = (1 - (distance / container.width)) * 100
        
        let newHeight = originalSize.height + (featuredPercentage! * heightIncreaseFactor) / 100
        let newWidth = (originalSize.width / originalSize.height) * newHeight
		
        //size changes relating to current size
        let increasedHeight = abs(self.frame.height - newHeight)
        let increasedWidth = abs(self.frame.width - newWidth)
		
        //position changes relating to current position
        let newX = (self.frame.width < newWidth) ? self.frame.origin.x - increasedWidth / 2 : self.frame.origin.x + increasedWidth / 2
        let newY = (self.frame.height < newHeight) ? self.frame.origin.y - increasedHeight : self.frame.origin.y + increasedHeight
        
        self.frame.size.width = CGFloat(newWidth)
        self.frame.size.height = CGFloat(newHeight)
        
        self.frame.origin.x = newX
        self.frame.origin.y = newY
        
        adjustShadow()
    
    }
    
	func adjustShadow() {
        let ft = (featuredPercentage != nil) ? featuredPercentage! : 0.0
        let defaultShadowRadius: CGFloat = 2
        var finalShadowRadius: CGFloat = 4
        
        if ft != 0.0 {
            
            finalShadowRadius = defaultShadowRadius * ft / (defaultShadowRadius * 10)
            
        }
        
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.18
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = finalShadowRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4).cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        mainBackground.layer.masksToBounds = true
        self.mainBackground.layer.borderWidth = 1
        self.mainBackground.layer.cornerRadius = 8
        self.mainBackground.layer.borderColor = UIColor.clear.cgColor

        self.layer.cornerRadius = 8
        self.layer.shadowOpacity = 0.18
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        
        iconImageView.layer.masksToBounds = true
        self.iconImageView.layer.cornerRadius = 50 / 100 * iconImageView.frame.size.width
        
    }

    private func updatedContext() {
        
        if let someContext = _context {
			nameLabel.text = someContext.name
			nameLabel.backgroundColor = someContext.color
			
			iconImageView.image = someContext.icon
			iconImageView.backgroundColor = someContext.color
			
		} else {
			nameLabel.text = NSLocalizedString("Add", comment: "Add Context Text")
			nameLabel.backgroundColor = UIColor.addContextColor
			
			iconImageView.image = #imageLiteral(resourceName: "AddIcon")
			iconImageView.backgroundColor = UIColor.addContextColor
			
			iconImageView.layer.borderWidth = 10
			iconImageView.layer.borderColor = UIColor.addContextColor.cgColor
		}
    }
}
