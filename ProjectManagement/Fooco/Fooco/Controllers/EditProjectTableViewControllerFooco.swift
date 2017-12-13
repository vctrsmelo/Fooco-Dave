//
//  EditProjectTableViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

protocol EditProjectTableViewControllerDelegate: AnyObject {
    func contextUpdated(for context: Context?)
    func estimatedHoursTouched(_ alertView: ((DatePickerAlertView) -> Void))
    func startingDateTouched(_ alertView: ((DatePickerAlertView) -> Void))
    func deadlineDateTouched(_ alertView: ((DatePickerAlertView) -> Void))
}

class EditProjectTableViewControllerFooco: UITableViewController {
	
	var viewModel: EditProjectViewModel!
	
	weak var delegate: EditProjectTableViewControllerDelegate?
	
	private var contextColor: UIColor {
		if let someSelectedContext = self.viewModel.chosenContext {
			return someSelectedContext.color
		} else {
			return .addContextColor
		}
	}
	
	@IBOutlet private weak var contextsCollectionView: UICollectionView!
	
	// name cell
	@IBOutlet private weak var nameIconImageView: UIImageView!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var nameTextField: UITextField!
	
	private var nameTextFieldBorder: CALayer!
	
	// estimated time cell
	@IBOutlet private weak var clockIconImageView: UIImageView!
	@IBOutlet private weak var estimatedTimeLabel: UILabel!
	@IBOutlet private weak var estimatedHoursButton: UIButton!
	
	// calendar cell
	@IBOutlet private weak var calendarIconImageView: UIImageView!
	@IBOutlet private weak var startsLabel: UILabel!
	@IBOutlet private weak var startingDateButton: UIButton!
	@IBOutlet private weak var deadlineLabel: UILabel!
	@IBOutlet private weak var deadlineDateButton: UIButton!
	
	@IBOutlet private weak var datesBarView: UIView!
	
	// importance cell
	@IBOutlet private weak var importanceIconImageView: UIImageView!
	@IBOutlet private weak var importanceLabel: UILabel!
	@IBOutlet private weak var lowImportanceButton: UIButton!
	@IBOutlet private weak var mediumImportanceButton: UIButton!
	@IBOutlet private weak var highImportanceButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		convertIconsToTemplate()
		designElements()
		
		// design contextCollectionView layout
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
		
		self.updateProjectData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let someContext = self.viewModel.chosenContext, let index = User.sharedInstance.contexts.index(of: someContext) {
			let indexPath = IndexPath(row: index, section: 0)
			self.contextsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		}
	}
	
	private func convertIconsToTemplate() {
		nameIconImageView.image = nameIconImageView.image!.withRenderingMode(.alwaysTemplate)
		clockIconImageView.image = clockIconImageView.image!.withRenderingMode(.alwaysTemplate)
		calendarIconImageView.image = calendarIconImageView.image!.withRenderingMode(.alwaysTemplate)
		importanceIconImageView.image = importanceIconImageView.image!.withRenderingMode(.alwaysTemplate)
	}
	
	private func designElements() {
		// Textfield
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
		
		lowImportanceButton.setTitleColor(UIColor.Interface.iWhite, for: UIControlState.selected)
		lowImportanceButton.setTitleColor(UIColor.Interface.iWhite, for: UIControlState.selected)
		lowImportanceButton.setTitleColor(UIColor.Interface.iWhite, for: UIControlState.selected)
		
		updateColor()
	}
	
	private func updateColor() {
		nameIconImageView.tintColor = contextColor
		nameLabel.textColor = contextColor
		nameTextField.textColor = contextColor
		nameTextField.text = nameTextField.text // It's stupid but updates the color properly
		nameTextFieldBorder.borderColor = contextColor.cgColor
		
		clockIconImageView.tintColor = contextColor
		estimatedTimeLabel.textColor = contextColor
		estimatedHoursButton.setTitleColor(contextColor)
		
		calendarIconImageView.tintColor = contextColor
		startsLabel.textColor = contextColor
		deadlineLabel.textColor = contextColor
		startingDateButton.setTitleColor(contextColor)
		deadlineDateButton.setTitleColor(contextColor)
		datesBarView.backgroundColor = contextColor
		
		importanceIconImageView.tintColor = contextColor
		importanceLabel.textColor = contextColor
		
		lowImportanceButton.layer.borderColor = contextColor.cgColor
		mediumImportanceButton.layer.borderColor = contextColor.cgColor
		highImportanceButton.layer.borderColor = contextColor.cgColor
		updateImportanceColor()
	}
	
	private func updateImportanceColor() {
		switch self.viewModel.importance {
		case 1:
			lowImportanceButton.backgroundColor = contextColor
			lowImportanceButton.setTitleColor(UIColor.Interface.iWhite)
			mediumImportanceButton.backgroundColor = UIColor.clear
			mediumImportanceButton.setTitleColor(contextColor)
			highImportanceButton.backgroundColor = UIColor.clear
			highImportanceButton.setTitleColor(contextColor)
			
		case 2:
			lowImportanceButton.backgroundColor = UIColor.clear
			lowImportanceButton.setTitleColor(contextColor)
			mediumImportanceButton.backgroundColor = contextColor
			mediumImportanceButton.setTitleColor(UIColor.Interface.iWhite)
			highImportanceButton.backgroundColor = UIColor.clear
			highImportanceButton.setTitleColor(contextColor)
			
		case 3:
			lowImportanceButton.backgroundColor = UIColor.clear
			lowImportanceButton.setTitleColor(contextColor)
			mediumImportanceButton.backgroundColor = UIColor.clear
			mediumImportanceButton.setTitleColor(contextColor)
			highImportanceButton.backgroundColor = contextColor
			highImportanceButton.setTitleColor(UIColor.Interface.iWhite)
			
		default:
			break
		}
	}
	
	private func updateSelectedContext(with context: Context?) {
		self.viewModel.chosenContext = context
		updateColor()
	}
	
	private func updateProjectData() {
//		self.delegate?.contextUpdated(for: self.selectedContext)
		self.nameTextField.text = self.viewModel.name
//		self.startingDateButton.setTitle(DateFormatter.localizedString(from: self.startingDate, dateStyle: .short, timeStyle: .none))
//		self.deadlineDateButton.setTitle(DateFormatter.localizedString(from: self.deadlineDate, dateStyle: .short, timeStyle: .none))
//		let localizedTitle = String(format: NSLocalizedString("%d days and %d hours", comment: "Estimated time phrase"), days, hours)
//		self.estimatedHoursButton.setTitle(localizedTitle)
		
		self.updateColor()
	}
	
	// MARK: - Touch Handling
	
	@IBAction func estimatedHoursTouched(_ sender: UIButton) {
		delegate?.estimatedHoursTouched { alertView in
			let pickerAlertViewModel = self.viewModel.createAlert(for: .estimatedTime)
			
			alertView.present(with: pickerAlertViewModel)
		}
	}
	
	@IBAction func startingDateTouched(_ sender: UIButton) {
		delegate?.startingDateTouched { alertView in
			let pickerAlertViewModel = self.viewModel.createAlert(for: .startingDate)
			
			alertView.present(with: pickerAlertViewModel)
		}
		
	}
	
	@IBAction func deadlineDateTouched(_ sender: UIButton) {
		delegate?.deadlineDateTouched { alertView in
			let pickerAlertViewModel = self.viewModel.createAlert(for: .endingDate)
			
			alertView.present(with: pickerAlertViewModel)
		}
	}
	
	@IBAction func lowImportanceTouched(_ sender: UIButton) {
		self.viewModel.importance = 1
		lowImportanceButton.isSelected = true
		mediumImportanceButton.isSelected = false
		highImportanceButton.isSelected = false
		self.updateImportanceColor()
	}
	
	
	@IBAction func mediumImportanceTouched(_ sender: UIButton) {
		self.viewModel.importance = 2
		lowImportanceButton.isSelected = false
		mediumImportanceButton.isSelected = true
		highImportanceButton.isSelected = false
		self.updateImportanceColor()
	}
	
	@IBAction func highImportanceTouched(_ sender: Any) {
		self.viewModel.importance = 3
		lowImportanceButton.isSelected = false
		mediumImportanceButton.isSelected = false
		highImportanceButton.isSelected = true
		self.updateImportanceColor()
	}
}

// MARK: - Collection

extension EditProjectTableViewControllerFooco: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            if self.viewModel.chosenContext == nil {
                updateSelectedContext(with: cell.context)
            }
        }
        
        return cell
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

// MARK: - Scroll

extension EditProjectTableViewControllerFooco {
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
        focusContextCell()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		focusContextCell()
    }
    
	private func focusContextCell(chosenCell: EditProjectContextCell? = nil) {
        
        let screenCenterX: CGFloat = contextsCollectionView.frame.origin.x + contextsCollectionView.frame.size.width / 2.0
		
		var focusedCell: EditProjectContextCell
		
		if let aCell = chosenCell {
			focusedCell = aCell
			
		} else if let anotherCell = contextsCollectionView.visibleCells.first as? EditProjectContextCell {
			focusedCell = anotherCell
			
		} else {
			return
		}
		
        
        let focusedCellAttributes = contextsCollectionView.layoutAttributesForItem(at: contextsCollectionView.indexPath(for: focusedCell)!)
        let focusedCellFrame = contextsCollectionView.convert(focusedCellAttributes!.frame, to: contextsCollectionView.superview!)
        var focusedCellCenterX = focusedCellFrame.origin.x + focusedCellFrame.size.width / 2.0
        
        for cell in contextsCollectionView.visibleCells {
            
            let cellAttributes = contextsCollectionView.layoutAttributesForItem(at: contextsCollectionView.indexPath(for: cell)!)
            let cellFrame = contextsCollectionView.convert(cellAttributes!.frame, to: contextsCollectionView.superview!)
            let cellCenterX = cellFrame.origin.x + cellFrame.size.width / 2.0
            
            if abs(screenCenterX - focusedCellCenterX) > abs(screenCenterX - cellCenterX) {
                focusedCell = cell as! EditProjectContextCell
                focusedCellCenterX = cellCenterX
            }
            
        }
        updateSelectedContext(with: focusedCell.context)
        contextsCollectionView.scrollToItem(at: contextsCollectionView.indexPath(for: focusedCell)!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }

}
