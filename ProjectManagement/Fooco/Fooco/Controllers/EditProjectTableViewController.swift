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
    
    var selectedContext: Context? = nil
    
    override func viewDidLoad() {
        
        //set delegate and data source
        contextsCollectionView.delegate = self
        contextsCollectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = contextsCollectionView.frame.size
        layout.minimumInteritemSpacing = 80
        layout.minimumLineSpacing = 80
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        contextsCollectionView.collectionViewLayout = layout
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        if selectedContext == nil {
            updateSelectedContext(with: cell.context)
        }
        
        let cellFrame = contextsCollectionView.convert(cell.frame, to: contextsCollectionView.superview)
        cell.updateSize(cellFrame: cellFrame, container: collectionView.frame)
        
        if indexPath.row >= User.sharedInstance.contexts.count {
            
            cell.context = nil
            return cell
            
        } else {
            let context = User.sharedInstance.contexts[indexPath.row]
            cell.context = context
        }
        
        return cell
        
    }
    
    private func updateSelectedContext(with context: Context?) {
        
      selectedContext = context
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: EditProjectContextCell.originalSize.width, height: EditProjectContextCell.originalSize.height)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == contextsCollectionView {
            for cell in contextsCollectionView.visibleCells {
                
                guard let contextCell = cell as? EditProjectContextCell else { return }
                let cellFrame = contextsCollectionView.convert(contextCell.frame, to: contextsCollectionView.superview)
                contextCell.updateSize(cellFrame: cellFrame, container: contextsCollectionView.frame)
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = EditProjectContextCell.originalSize.width * CGFloat(collectionView.visibleCells.count)
        let totalSpacingWidth = 10 * (collectionView.visibleCells.count - 1)

        let leftInset = (collectionView.frame.size.width - CGFloat(EditProjectContextCell.originalSize.width + 10)) / 2
        let rightInset = leftInset

        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == contextsCollectionView {
            focusContextCell()
        }
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        focusContextCell()
    }
    
    private func focusContextCell() {
        
        let screenCenterX: CGFloat = contextsCollectionView.frame.origin.x + contextsCollectionView.frame.size.width/2.0
        
        guard var focusedCell: EditProjectContextCell = contextsCollectionView.visibleCells.first as? EditProjectContextCell else { return }
        
        let focusedCellAttributes = contextsCollectionView.layoutAttributesForItem(at: contextsCollectionView.indexPath(for: focusedCell)!)
        let focusedCellFrame = contextsCollectionView.convert(focusedCellAttributes!.frame, to: contextsCollectionView.superview!)
        var focusedCellCenterX = focusedCellFrame.origin.x + focusedCellFrame.size.width/2.0
        
        for cell in contextsCollectionView.visibleCells {
            
            let cellAttributes = contextsCollectionView.layoutAttributesForItem(at: contextsCollectionView.indexPath(for: cell)!)
            let cellFrame = contextsCollectionView.convert(cellAttributes!.frame, to: contextsCollectionView.superview!)
            let cellCenterX = cellFrame.origin.x + cellFrame.size.width/2.0
            
            if (abs(screenCenterX-focusedCellCenterX) > abs(screenCenterX-cellCenterX)) {
                focusedCell = cell as! EditProjectContextCell
                focusedCellCenterX = cellCenterX
            }
            
        }
        updateSelectedContext(with: focusedCell.context)
        contextsCollectionView.scrollToItem(at: contextsCollectionView.indexPath(for: focusedCell)!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
    }
    
}

