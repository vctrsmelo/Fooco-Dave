//
//  EditProjectViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit
import Foundation

class EditProjectViewControllerFooco: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var editProjectContainerView: EditProjectContainerView!
    
    
    
    
    var project: Project?
    
    override func viewDidLoad() {

        //delegates and data sources
        formatNavigationBar()
        
    }
    
    /**
     Format navigation bar design
    */
    private func formatNavigationBar() {
        
        //TODO: edit here to get the current context selected color
        guard let mainColor = UIColor.contextColors().first else {
            return
        }
        
        navigationBar.removeBackground()
        
    }
    
}

extension EditProjectViewControllerFooco: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 0, height: 0)
        
    }
    
}
