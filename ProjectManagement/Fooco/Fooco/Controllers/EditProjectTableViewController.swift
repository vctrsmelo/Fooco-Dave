//
//  EditProjectTableViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import Foundation
import UIKit

class EditProjectTableViewController: UITableViewController {
    
    @IBOutlet weak var contextsCollectionView: UICollectionView!
    
    var selectedContextIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        
        //set delegate and data source
        contextsCollectionView.delegate = self
        contextsCollectionView.dataSource = self
        
        let nib = UINib(nibName: "EditProjectContextCell", bundle: nil)
        contextsCollectionView.register(nib, forCellWithReuseIdentifier: "contextCell")

    }
}

extension EditProjectTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.sharedInstance.contexts.count+3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contextCell", for: indexPath) as! EditProjectContextCell
        
        if selectedContextIndexPath == nil {
            updateSelectedContext(with: indexPath)
        }
        
        if indexPath.row >= User.sharedInstance.contexts.count {
            
            cell.context = nil
            return cell
            
        } else {
            let context = User.sharedInstance.contexts[indexPath.row]
            cell.context = context
        }
        
        return cell
    }
    
    private func updateSelectedContext(with indexPath: IndexPath) {
        
      selectedContextIndexPath = indexPath
        
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 174, height: 121)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 174 * collectionView.visibleCells.count
        let totalSpacingWidth = 10 * (collectionView.visibleCells.count - 1)
        
        let leftInset = (collectionView.frame.size.width - CGFloat(174 + 10)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
}

