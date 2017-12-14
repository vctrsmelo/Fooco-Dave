//
//  EditProjectTableViewController.swift
//  Fooco
//
//  Created by Victor Melo on 08/11/17.
//

import UIKit

protocol EditProjectTableViewControllerDelegate: AnyObject {
    func contextUpdated()
    func presentPickerAlert(with pickerAlertViewModel: PickerAlertViewModel)
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
		
		self.designElements()
		
		self.updateProjectInfo()
		self.updateColor()
		
		let nib = UINib(nibName: "EditProjectContextCell", bundle: nil)
		contextsCollectionView.register(nib, forCellWithReuseIdentifier: "contextCell")
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
		self.convertIconsToTemplate()
		
		lowImportanceButton.layer.borderWidth = 1
		mediumImportanceButton.layer.borderWidth = 1
		highImportanceButton.layer.borderWidth = 1
		
		// Textfield
		let border = CALayer()
		let width = CGFloat(1.0)
		border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width:  nameTextField.frame.size.width, height: nameTextField.frame.size.height)
		border.borderWidth = width
		nameTextFieldBorder = border
		nameTextField.layer.addSublayer(border)
		nameTextField.layer.masksToBounds = true
		
		// Design contextCollectionView layout
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.itemSize = contextsCollectionView.frame.size
		layout.minimumInteritemSpacing = 80
		layout.minimumLineSpacing = 80
		layout.scrollDirection = UICollectionViewScrollDirection.horizontal
		contextsCollectionView.collectionViewLayout = layout
		contextsCollectionView.showsHorizontalScrollIndicator = false
	}
	
	private func updateColor() {
		self.delegate?.contextUpdated()
		
		nameIconImageView.tintColor = contextColor
		nameLabel.textColor = contextColor
		nameTextField.textColor = contextColor
		nameTextField.text = nameTextField.text // It's stupid but updates the color properly
		nameTextFieldBorder.borderColor = contextColor.cgColor
		
		clockIconImageView.tintColor = contextColor
		estimatedTimeLabel.textColor = contextColor
		estimatedHoursButton.setTitleColor(contextColor, for: .normal)
		
		calendarIconImageView.tintColor = contextColor
		startsLabel.textColor = contextColor
		deadlineLabel.textColor = contextColor
		startingDateButton.setTitleColor(contextColor, for: .normal)
		deadlineDateButton.setTitleColor(contextColor, for: .normal)
		datesBarView.backgroundColor = contextColor
		
		importanceIconImageView.tintColor = contextColor
		importanceLabel.textColor = contextColor
		
		lowImportanceButton.layer.borderColor = contextColor.cgColor
		mediumImportanceButton.layer.borderColor = contextColor.cgColor
		highImportanceButton.layer.borderColor = contextColor.cgColor
		
		self.updateImportanceColor()
	}
	
	private func updateImportanceColor() {
		lowImportanceButton.setTitleColor(contextColor, for: .normal)
		mediumImportanceButton.setTitleColor(contextColor, for: .normal)
		highImportanceButton.setTitleColor(contextColor, for: .normal)
		
		switch self.viewModel.importance {
		case 1:
			lowImportanceButton.backgroundColor = contextColor
			mediumImportanceButton.backgroundColor = UIColor.clear
			highImportanceButton.backgroundColor = UIColor.clear
			
		case 2:
			lowImportanceButton.backgroundColor = UIColor.clear
			mediumImportanceButton.backgroundColor = contextColor
			highImportanceButton.backgroundColor = UIColor.clear
			
		case 3:
			lowImportanceButton.backgroundColor = UIColor.clear
			mediumImportanceButton.backgroundColor = UIColor.clear
			highImportanceButton.backgroundColor = contextColor
			
		default:
			break
		}
	}
	
	private func updateSelectedContext(with context: Context?) {
		self.viewModel.chosenContext = context
		updateColor()
	}
	
	private func updateProjectInfo() {
		self.nameTextField.text = self.viewModel.name
		self.updateSelectedImportance()
		self.startingDateButton.setTitle(self.viewModel.startDateString, for: .normal)
		self.deadlineDateButton.setTitle(self.viewModel.endDateString, for: .normal)
		self.estimatedHoursButton.setTitle(self.viewModel.estimatedTimeString, for: .normal)
	}
	
	private func updateSelectedImportance() {
		switch self.viewModel.importance {
		case 1:
			lowImportanceButton.isSelected = true
			mediumImportanceButton.isSelected = false
			highImportanceButton.isSelected = false
		
		case 2:
			lowImportanceButton.isSelected = false
			mediumImportanceButton.isSelected = true
			highImportanceButton.isSelected = false
			
		case 3:
			lowImportanceButton.isSelected = false
			mediumImportanceButton.isSelected = false
			highImportanceButton.isSelected = true
		
		default:
			break
		}
	}
	
	// MARK: - Touch Handling
	
	@IBAction func estimatedHoursTouched(_ sender: UIButton) {
		let pickerAlertViewModel = self.viewModel.createAlert(for: .estimatedTime)
		delegate?.presentPickerAlert(with: pickerAlertViewModel)
	}
	
	@IBAction func startingDateTouched(_ sender: UIButton) {
		let pickerAlertViewModel = self.viewModel.createAlert(for: .startingDate)
		delegate?.presentPickerAlert(with: pickerAlertViewModel)
		
	}
	
	@IBAction func deadlineDateTouched(_ sender: UIButton) {
		let pickerAlertViewModel = self.viewModel.createAlert(for: .endingDate)
		delegate?.presentPickerAlert(with: pickerAlertViewModel)
	}
	
	@IBAction func lowImportanceTouched(_ sender: UIButton) {
		self.viewModel.importance = 1
		self.updateSelectedImportance()
		self.updateImportanceColor()
	}
	
	
	@IBAction func mediumImportanceTouched(_ sender: UIButton) {
		self.viewModel.importance = 2
		self.updateSelectedImportance()
		self.updateImportanceColor()
	}
	
	@IBAction func highImportanceTouched(_ sender: Any) {
		self.viewModel.importance = 3
		self.updateSelectedImportance()
		self.updateImportanceColor()
	}
}

// MARK: - TextField

extension EditProjectTableViewControllerFooco: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.resignFirstResponder()
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		self.viewModel.name = textField.text
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
