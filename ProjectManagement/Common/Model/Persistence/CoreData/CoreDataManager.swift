//
//  CoreDataManager.swift
//  Fooco
//
//  Created by Victor S Melo on 23/01/18.
//

import Foundation
import CoreData
import UIKit

enum Entity: String {
    case projectEntity = "ProjectEntity"
}

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    private init() {
        
    }
    
    /**
     Get the appDelegate persistentContainer view context.
    */
    func getContext() -> NSManagedObjectContext? {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        return appDelegate.persistentContainer.viewContext


    
    }
    
}
