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

class EditProjectTableViewController: UITableViewController {
    
    @IBOutlet weak var contextsCollectionView: UICollectionView!
    
    weak var delegate: EditProjectTableViewControllerDelegate?
    
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
		if _selectedContext == nil {
			return UIColor.colorOfAddContext()
		}
		
		return _selectedContext!.color
	}
	
    private var _importance: Int = 1
    var importance: Int {
        set {
            _importance = newValue
            updateImportanceColor(to: newValue)
        }
        get {
            return _importance
        }
    }
    
    //name cell
    @IBOutlet private weak var nameIconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    private var nameTextFieldBorder: CALayer!
    
    //estimated time cell
    @IBOutlet private weak var clockIconImageView: UIImageView!
    @IBOutlet private weak var estimatedTimeLabel: UILabel!
    @IBOutlet private weak var estimatedHoursButton: UIButton!
    
    //calendar cell
    @IBOutlet private weak var calendarIconImageView: UIImageView!
    @IBOutlet private weak var startsLabel: UILabel!
    @IBOutlet private weak var startingDateButton: UIButton!
    @IBOutlet private weak var deadlineLabel: UILabel!
    @IBOutlet private weak var deadlineDateButton: UIButton!
    
    @IBOutlet private weak var datesBarView: UIView!
    
    //importance cell
    @IBOutlet private weak var importanceIconImageView: UIImageView!
    @IBOutlet private weak var importanceLabel: UILabel!
    @IBOutlet private weak var lowImportanceButton: UIButton!
    @IBOutlet private weak var mediumImportanceButton: UIButton!
    @IBOutlet private weak var highImportanceButton: UIButton!
    
    private var startingDate: Date!
    private var deadlineDate: Date!
    private var estimatedTime: TimeInterval!
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        convertIconsToTemplate()
        designElements()
        
        //set delegate and data source
        contextsCollectionView.delegate = self
        contextsCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //disable table scrolling
        tableView.alwaysBounceVertical = false
        
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
            lowImportanceButton.setTitleColor(UIColor.white)
            mediumImportanceButton.backgroundColor = UIColor.clear
            mediumImportanceButton.setTitleColor(contextColor)
            highImportanceButton.backgroundColor = UIColor.clear
            highImportanceButton.setTitleColor(contextColor)
            break
        case 2:
            lowImportanceButton.backgroundColor = UIColor.clear
            lowImportanceButton.setTitleColor(contextColor)
            mediumImportanceButton.backgroundColor = contextColor
            mediumImportanceButton.setTitleColor(UIColor.white)
            highImportanceButton.backgroundColor = UIColor.clear
            highImportanceButton.setTitleColor(contextColor)
            break
        case 3:
            lowImportanceButton.backgroundColor = UIColor.clear
            lowImportanceButton.setTitleColor(contextColor)
            mediumImportanceButton.backgroundColor = UIColor.clear
            mediumImportanceButton.setTitleColor(contextColor)
            highImportanceButton.backgroundColor = contextColor
            highImportanceButton.setTitleColor(UIColor.white)
            break
        default:
            break
        }
    }
    
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
            
            alertView.present(.startingDate, initialDate: startingDate)
           
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
            
            alertView.present(.deadlineDate, initialDate: deadlineDate)
            
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

extension EditProjectTableViewController: DatePickerAlertViewDelegate {
    
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
            
            break
        case .deadlineDate:
            
            if startingDate != nil {
                let daysBetween = Calendar.current.dateComponents([.day], from: startingDate, to: currentDate)
                
                if daysBetween.day != nil {
                    newUnderTitleString = "\(daysBetween.day!) days since starting date"
                }
            }
            
            break
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
        estimatedHoursButton.setTitle("\(days) days and \(hours) hours")
        
        estimatedTime = TimeInterval(days * 24 * 60 * 60)
        estimatedTime = estimatedTime! + TimeInterval(hours * 60 * 60)
    }
    
    func confirmTouched(_ sender: UIDatePicker, for mode: AlertPickerViewMode) {
        sender.isHidden = true
    
        
        //necessary to keep the dates as date (makes it easier to display the value later into alert view, if needed)
        switch mode {
            case .startingDate:
                startingDate = sender.date
                startingDateButton.setTitle(DateFormatter.localizedString(from: sender.date, dateStyle: .short, timeStyle: .none))
                
                break
            case .deadlineDate:
                deadlineDate = sender.date
                deadlineDateButton.setTitle(DateFormatter.localizedString(from: sender.date, dateStyle: .short, timeStyle: .none))
                break
            default:
                break
        }
        
    }
    
}
