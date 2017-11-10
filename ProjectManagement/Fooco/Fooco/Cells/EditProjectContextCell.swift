//
//  EditProjectContextCell.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

class EditProjectContextCell: UICollectionViewCell {
    
    var icon: UIImage!
    
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
    
    private func updatedContext() {
        
        if _context == nil {
            
            nameLabel.text = "Add"
            iconImageView.image = #imageLiteral(resourceName: "AddIcon")
            return
            
        }
        
        nameLabel.text = _context.name
        iconImageView.image = _context.icon
        
        iconImageView.backgroundColor = _context.color
        self.backgroundColor = _context.color
    }
}
