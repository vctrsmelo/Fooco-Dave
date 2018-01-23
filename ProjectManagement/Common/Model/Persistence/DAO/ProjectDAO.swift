//
//  ProjectDAO.swift
//  Fooco
//
//  Created by Victor S Melo on 23/01/18.
//

import Foundation

protocol ProjectDAO {
    
    func save(_ project: Project)
    func delete(_ projectId: UUID)
    
    /**
     Get all projects from DB, with option to filter by context or importance.
    */
    func getAll(byContext: Context?, withImportance: Int?) -> [Project]
    
}

