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
	
	var project: Project?
	
	weak var delegate: EditProjectTableViewControllerDelegate?
	
	private var startingDate: Date! {
		didSet {
			self.startingDateButton.setTitle(DateFormatter.localizedString(from: self.startingDate, dateStyle: .short, timeStyle: .none))
		}
	}
	private var deadlineDate: Date! {
		didSet {
			self.deadlineDateButton.setTitle(DateFormatter.localizedString(from: self.deadlineDate, dateStyle: .short, timeStyle: .none))
		}
	}
	private var estimatedTime: TimeInterval! {
		didSet {
			let days = Int(self.estimatedTime) / Int(1.day)
			let hours = Int(self.estimatedTime.truncatingRemainder(dividingBy: 1.day) / 1.hour)
			
			let localizedTitle = String(format: NSLocalizedString("%d days and %d hours", comment: "Estimated time phrase"), days, hours)
			self.estimatedHoursButton.setTitle(localizedTitle)
		}
	}
	
	private var selectedContext: Context? {
		didSet {
			self.delegate?.contextUpdated(for: self.selectedContext)
		}
	}
	
	private var contextColor: UIColor {
		if let someSelectedContext = self.selectedContext {
			return someSelectedContext.color
		} else {
			return .addContextColor
		}
	}
	
	private var importance: Int = 1 {
		willSet {
			self.updateImportanceColor(to: newValue)
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
		
		if let someContext = self.selectedContext, let index = User.sharedInstance.contexts.index(of: someContext) {
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
		updateImportanceColor(to: importance)
	}
	
	private func updateImportanceColor(to value: Int) {
		switch value {
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
		selectedContext = context
		updateColor()
	}
	
	private func updateProjectData() {
		self.nameTextField.text = self.project?.name ?? ""
		self.startingDate = self.project?.startingDate ?? Date()
		self.deadlineDate = self.project?.endingDate ?? Date().addingTimeInterval(7.days)
		self.selectedContext = self.project?.context
		self.importance = self.project?.importance ?? 1
		self.estimatedTime = self.project?.totalTimeEstimated ?? 0
		
		self.updateColor()
	}
	
	func saveProject() -> Project? {
		if let name = self.nameTextField.text, let begin = self.startingDate, let end = self.deadlineDate, let context = self.selectedContext, let estimate = self.estimatedTime {
			
			if let someProject = self.project {
				someProject.name = name
				someProject.startingDate = begin
				someProject.endingDate = end
				someProject.context = context
				someProject.importance = self.importance
				someProject.totalTimeEstimated = estimate
				
				return someProject
				
			} else {
				return Project(named: name, startsAt: begin, endsAt: end, withContext: context, importance: self.importance, totalTimeEstimated: estimate)
			}
			
		} else {
			return nil
		}
	}
	
	// MARK: - Touch Handling
	
	@IBAction func estimatedHoursTouched(_ sender: UIButton) {
		delegate?.estimatedHoursTouched { alertView in
			alertView.present(.estimatedTime)
			
			let contextName = (selectedContext != nil) ? selectedContext!.name : ""
			let days = alertView.hoursPicker.selectedRow(inComponent: 0)
			let hours = alertView.hoursPicker.selectedRow(inComponent: 1)
			
			alertView.overTitleLabel.text = "\(contextName) Project"
			alertView.titleLabel.text = "Estimated Time"
			alertView.underTitleLabel.text = "\(days) days and \(hours) hours"
		}
	}
	
	@IBAction func startingDateTouched(_ sender: UIButton) {
		delegate?.startingDateTouched { alertView in
			
			alertView.present(.startingDate, initialDate: startingDate, limitDate: deadlineDate)
			
			let contextName = (selectedContext != nil) ? selectedContext!.name : ""
			let projectName = (nameTextField != nil && nameTextField!.text != nil) ? nameTextField!.text! : ""
			
			let currentDate = alertView.datePicker.date
			
			alertView.underTitleLabel.text = ""
			alertView.overTitleLabel.text = "\(contextName) \(projectName)"
			alertView.titleLabel.text = "Starting Date"
			
			if deadlineDate != nil {
				let daysBetween = Calendar.current.dateComponents([.day], from: currentDate, to: deadlineDate)
				if daysBetween.day != nil {
					alertView.underTitleLabel.text = "\(daysBetween.day!) days until deadline"
				}
			}
			
		}
		
	}
	
	@IBAction func deadlineDateTouched(_ sender: UIButton) {
		delegate?.deadlineDateTouched { alertView in
			alertView.present(.deadlineDate, initialDate: deadlineDate, limitDate: startingDate)
			
			let contextName = (selectedContext != nil) ? selectedContext!.name : ""
			let projectName = (nameTextField != nil && nameTextField!.text != nil) ? nameTextField!.text! : ""
			
			let currentDate = alertView.datePicker.date
			
			alertView.underTitleLabel.text = ""
			
			if startingDate != nil {
				let daysBetween = Calendar.current.dateComponents([.day], from: startingDate, to: currentDate)
				if daysBetween.day != nil {
					alertView.underTitleLabel.text = "\(daysBetween.day!) days since starting date"
				}
			}
			
			alertView.overTitleLabel.text = "\(contextName) \(projectName)"
			alertView.titleLabel.text = "Ending Date"
		}
	}
	
	@IBAction func lowImportanceTouched(_ sender: UIButton) {
		importance = 1
		lowImportanceButton.isSelected = true
		mediumImportanceButton.isSelected = false
		highImportanceButton.isSelected = false
	}
	
	
	@IBAction func mediumImportanceTouched(_ sender: UIButton) {
		importance = 2
		lowImportanceButton.isSelected = false
		mediumImportanceButton.isSelected = true
		highImportanceButton.isSelected = false
	}
	
	@IBAction func highImportanceTouched(_ sender: Any) {
		importance = 3
		lowImportanceButton.isSelected = false
		mediumImportanceButton.isSelected = false
		highImportanceButton.isSelected = true
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
            if selectedContext == nil {
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

// MARK: - DatePickerAlertViewDelegate

extension EditProjectTableViewControllerFooco: DatePickerAlertViewDelegate {
    
    func dateChanged(_ sender: UIDatePicker, at alertView: DatePickerAlertView, for mode: AlertPickerViewMode) {
        
        let currentDate = alertView.datePicker.date
        var newUnderTitleString = ""
        
        switch mode {
        case .startingDate:
            
            if deadlineDate != nil {
                let daysBetween = Calendar.current.dateComponents([.day], from: currentDate, to: deadlineDate)
                
                if daysBetween.day != nil {
                    newUnderTitleString = "\(daysBetween.day!) days until deadline"
                }
            }
			
        case .deadlineDate:
            
            if startingDate != nil {
                let daysBetween = Calendar.current.dateComponents([.day], from: startingDate, to: currentDate)
                
                if daysBetween.day != nil {
                    newUnderTitleString = "\(daysBetween.day!) days since starting date"
                }
            }
			
        default:
            break
        }
        
        alertView.underTitleLabel.text = newUnderTitleString
    }
    
    func confirmTouched(_ sender: UIPickerView, for mode: AlertPickerViewMode) {
        sender.isHidden = true
        
        if mode != .estimatedTime {
            return
        }
        
        let days = sender.selectedRow(inComponent: 0)
        let hours = sender.selectedRow(inComponent: 1)
		
        estimatedTime = TimeInterval(days.days + hours.hours)
    }
    
    func confirmTouched(_ sender: UIDatePicker, for mode: AlertPickerViewMode) {
        sender.isHidden = true
		
        // necessary to keep the dates as date (makes it easier to display the value later into alert view, if needed)
        switch mode {
            case .startingDate:
                startingDate = sender.date
			
            case .deadlineDate:
                deadlineDate = sender.date

            default:
                break
        }
    }
}
