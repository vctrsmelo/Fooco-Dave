//
//  EditProjectContextCell.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

class EditProjectContextCell: UICollectionViewCell {
    
    var icon: UIImage!
    
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    
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
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
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
        
        if _context == nil {
            
            nameLabel.text = "Add"
            iconImageView.image = #imageLiteral(resourceName: "AddIcon")
            nameLabel.backgroundColor = UIColor.blue
            return
            
        }
        
        nameLabel.text = _context.name
        iconImageView.image = _context.icon
        
        iconImageView.backgroundColor = _context.color
        self.backgroundColor = _context.color
    }
}
