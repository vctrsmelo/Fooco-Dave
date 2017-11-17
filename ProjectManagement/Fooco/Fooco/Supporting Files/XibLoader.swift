//
//  XibLoader.swift
//  Task Assistant
//
//  Created by Rodrigo Cardoso Buske on 04/07/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import UIKit

protocol XibLoader : class {
    var nibName : String { get }
    var view : UIView! { get set}
    
    func initialSetup()
    func xibSetup()
    func loadViewFromNib() -> UIView
}

extension XibLoader where Self : UIView{
    func initialSetup() {
        self.xibSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib()
        
        self.view.frame = self.bounds
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
