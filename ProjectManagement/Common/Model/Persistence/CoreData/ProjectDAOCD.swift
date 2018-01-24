//
//  ProjectDAOCD.swift
//  Fooco
//
//  Created by Victor S Melo on 23/01/18.
//

import Foundation
import CoreData

class ProjectDAOCD: ProjectDAO {
    
    func save(_ project: Project) {
        
        guard let managedContext = CoreDataManager.sharedInstance.getContext() else {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: Entity.projectEntity.rawValue, in: managedContext)
        
        let projectCD = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        projectCD.setValue(project.id, forKey: "uuid")
        projectCD.setValue(project.name, forKey: "name")
        projectCD.setValue(project.startingDate, forKey: "startingDate")
        projectCD.setValue(project.endingDate, forKey: "endingDate")
        projectCD.setValue(project.importance, forKey: "importance")
        projectCD.setValue(project.initialEstimatedTime, forKey: "initialEstimatedTime")
        projectCD.setValue(project.completedActivities, forKey: "completedActivities")
        projectCD.setValue(project.context, forKey: "context")
        
        
    }
    
    func delete(_ projectId: UUID) {

    }
    
    func getAll(byContext: Context?, withImportance: Int?) -> [Project] {
        return []
    }
    
    
    
    
}
