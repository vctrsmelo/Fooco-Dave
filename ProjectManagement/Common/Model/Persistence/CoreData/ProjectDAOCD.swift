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
        
        projectCD.setValue(project.id, forKey: "id")
        projectCD.setValue(project.name, forKey: "name")
        projectCD.setValue(project.startingDate, forKey: "startingDate")
        projectCD.setValue(project.endingDate, forKey: "endingDate")
        projectCD.setValue(project.importance, forKey: "importance")
        
        //definir lógica pra salvar contexto. Precisa ver se já existe. Caso já exista, referenciar ele. Caso contrário, criar e então refenciar o novo contexto criado.
        
        
        
        
    }
    
    func delete(_ projectId: UUID) {

    }
    
    func getAll(byContext: Context?, withImportance: Int?) -> [Project] {
        return []
    }
    
    
    
    
}
