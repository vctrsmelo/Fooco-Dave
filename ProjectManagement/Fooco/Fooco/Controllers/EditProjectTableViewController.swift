//
//  EditProjectTableViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import Foundation
import UIKit

protocol EditProjectContextUpdated {
    func contextUpdated(for context: Context?)
}

class EditProjectTableViewController: UITableViewController {
    
    @IBOutlet weak var contextsCollectionView: UICollectionView!
    
    var delegate: EditProjectContextUpdated?
    
    private var _selectedContext: Context?
    var selectedContext: Context? {
        set {
            _selectedContext = newValue
            delegate?.contextUpdated(for: newValue)
            
        }
        get {
            return _selectedContext
        }
    }
    
    var contextColor: UIColor {
        get {
            if _selectedContext == nil {
                return UIColor.colorOfAddContext()
            }

            return _selectedContext!.color
        }
    }
    
    var importance: Int = 1
    
    //name cell
    @IBOutlet weak var nameIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    private var nameTextFieldBorder: CALayer!
    
    //estimated time cell
    @IBOutlet weak var clockIconImageView: UIImageView!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var editableEstimatedHours: UILabel!
    
    //calendar cell
    @IBOutlet weak var calendarIconImageView: UIImageView!
    @IBOutlet weak var startsLabel: UILabel!
    @IBOutlet weak var startingDateLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    @IBOutlet weak var datesBarView: UIView!
    
    //importance cell
    @IBOutlet weak var importanceIconImageView: UIImageView!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var lowImportanceButton: UIButton!
    @IBOutlet weak var mediumImportanceButton: UIButton!
    @IBOutlet weak var highImportanceButton: UIButton!
    
    override func viewDidLoad() {
        
        convertIconsToTemplate()
        designElements()
        
        //set delegate and data source
        contextsCollectionView.delegate = self
        contextsCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //design contextCollectionView layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = contextsCollectionView.frame.size
        layout.minimumInteritemSpacing = 80
        layout.minimumLineSpacing = 80
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        contextsCollectionView.collectionViewLayout = layout
        contextsCollectionView.showsHorizontalScrollIndicator = false
        
        let nib = UINib(nibName: "EditProjectContextCell", bundle: nil)
        contextsCollectionView.register(nib, forCellWithReuseIdentifier: "contextCell")


    }
    
    private func convertIconsToTemplate() {
        
        nameIconImageView.image = nameIconImageView.image!.withRenderingMode(.alwaysTemplate)
        clockIconImageView.image = clockIconImageView.image!.withRenderingMode(.alwaysTemplate)
        calendarIconImageView.image = calendarIconImageView.image!.withRenderingMode(.alwaysTemplate)
        importanceIconImageView.image = importanceIconImageView.image!.withRenderingMode(.alwaysTemplate)

    }
    
    private func designElements() {
        //textfield
        let border = CALayer()
        let width = CGFloat(1.0)
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width:  nameTextField.frame.size.width, height: nameTextField.frame.size.height)
        border.borderWidth = width
        nameTextFieldBorder = border
        nameTextField.layer.addSublayer(border)
        nameTextField.layer.masksToBounds = true
        
        lowImportanceButton.layer.borderWidth = 1
        mediumImportanceButton.layer.borderWidth = 1
        highImportanceButton.layer.borderWidth = 1
        
        lowImportanceButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        lowImportanceButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        lowImportanceButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        
        updateColor()
        
    }
    
    private func updateColor() {
        nameIconImageView.tintColor = contextColor
        nameLabel.textColor = contextColor
        nameTextFieldBorder.borderColor = contextColor.cgColor
        
        clockIconImageView.tintColor = contextColor
        estimatedTimeLabel.textColor = contextColor
        editableEstimatedHours.textColor = contextColor
        
        calendarIconImageView.tintColor = contextColor
        startsLabel.textColor = contextColor
        deadlineLabel.textColor = contextColor
        startingDateLabel.textColor = contextColor
        deadlineDateLabel.textColor = contextColor
        datesBarView.backgroundColor = contextColor
        
        
        importanceIconImageView.tintColor = contextColor
        importanceLabel.textColor = contextColor
        lowImportanceButton.layer.borderColor = contextColor.cgColor
        lowImportanceButton.setTitleColor(contextColor, for: UIControlState.normal)
        mediumImportanceButton.layer.borderColor = contextColor.cgColor
        mediumImportanceButton.setTitleColor(contextColor, for: UIControlState.normal)
        highImportanceButton.layer.borderColor = contextColor.cgColor
        highImportanceButton.setTitleColor(contextColor, for: UIControlState.normal)
        
        switch importance {
        case 1:
            lowImportanceButton.isSelected = true
            lowImportanceButton.backgroundColor = contextColor
            break
        case 2:
            mediumImportanceButton.backgroundColor = contextColor
            mediumImportanceButton.titleLabel?.textColor = UIColor.white
            break
        case 3:
            highImportanceButton.backgroundColor = contextColor
            highImportanceButton.titleLabel?.textColor = UIColor.white
            break
        default:
            break
        }
        
        
    }
    
    @IBAction func lowImportanceTouched(_ sender: UIButton) {
        lowImportanceButton.backgroundColor = contextColor
        mediumImportanceButton.backgroundColor = UIColor.clear
        highImportanceButton.backgroundColor = UIColor.clear
        importance = 1
    }
    
    
    @IBAction func mediumImportanceTouched(_ sender: UIButton) {
        lowImportanceButton.backgroundColor = UIColor.clear
        mediumImportanceButton.backgroundColor = contextColor
        highImportanceButton.backgroundColor = UIColor.clear
        importance = 2
    }
    
    @IBAction func highImportanceTouched(_ sender: Any) {
        lowImportanceButton.backgroundColor = UIColor.clear
        mediumImportanceButton.backgroundColor = UIColor.clear
        highImportanceButton.backgroundColor = contextColor
        importance = 3
    }
    
}

extension EditProjectTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.sharedInstance.contexts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contextCell", for: indexPath) as! EditProjectContextCell
        
        let cellFrame = contextsCollectionView.convert(cell.frame, to: contextsCollectionView.superview)
        cell.updateSize(cellFrame: cellFrame, container: collectionView.frame)
        
        if indexPath.row >= User.sharedInstance.contexts.count {
            
            cell.context = nil
            return cell
            
        } else {
            let context = User.sharedInstance.contexts[indexPath.row]
            cell.context = context
            if selectedContext == nil {
                updateSelectedContext(with: cell.context)
            }

        }
        
        return cell
        
    }
    
    private func updateSelectedContext(with context: Context?) {
        
      selectedContext = context
      updateColor()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: EditProjectContextCell.originalSize.width, height: EditProjectContextCell.originalSize.height)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == contextsCollectionView {
            for cell in contextsCollectionView.visibleCells {
                
                guard let contextCell = cell as? EditProjectContextCell else {
                    return
                }
                let cellFrame = contextsCollectionView.convert(contextCell.frame, to: contextsCollectionView.superview)
                contextCell.updateSize(cellFrame: cellFrame, container: contextsCollectionView.frame)
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let leftInset = (collectionView.frame.size.width - CGFloat(EditProjectContextCell.originalSize.width + 10)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 40, left: leftInset, bottom: 0, right: rightInset)
    
    }
    
}

extension EditProjectTableViewController {
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
        focusContextCell()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        focusContextCell()
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
    
    private func focusContextCell() {
        
        let screenCenterX: CGFloat = contextsCollectionView.frame.origin.x + contextsCollectionView.frame.size.width / 2.0
        
        guard var focusedCell: EditProjectContextCell = contextsCollectionView.visibleCells.first as? EditProjectContextCell else {
            return
        }
        
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
