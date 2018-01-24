//
//  ContextDAOCD.swift
//  Fooco
//
//  Created by Victor S Melo on 23/01/18.
//

import Foundation
import CoreData

class ProjectCD: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var startingDate: Date
    @NSManaged var endingDate: Date
    @NSManaged var initialEstimatedTime: TimeInterval
    @NSManaged var importance: Int
    @NSManaged var completedActivities: [Activity]
    @NSManaged var context: Context

    
}
