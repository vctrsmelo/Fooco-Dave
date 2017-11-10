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
    
    override func viewDidLoad() {
        
        //set delegate and data source
        contextsCollectionView.delegate = self
        contextsCollectionView.dataSource = self

    }
}

extension EditProjectTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.sharedInstance.contexts.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contextCell", for: indexPath) as! EditProjectContextCell

        if indexPath.row >= User.sharedInstance.contexts.count {
            
            cell.context = nil
            return cell
            
        } else {
            let context = User.sharedInstance.contexts[indexPath.row]
            cell.context = context
        }
        return cell
    }
    
}

