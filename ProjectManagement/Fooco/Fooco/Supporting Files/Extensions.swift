//
//  Extensions.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

extension UINavigationBar {
    func removeBackground() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
