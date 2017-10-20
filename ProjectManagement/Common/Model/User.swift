//
//  User.swift
//  Fooco
//
//  Created by Victor Melo on 18/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var projects: [Project]
    var contexts: [Context]
    var week: Week
    
    var schedule: [Activity]
    
    init(projects projs: [Project] = [], contexts ctxs: [Context] = [], week wk: Week = Week()) {
        
        projects = projs
        contexts = ctxs
        week = wk
        schedule = getSchedule(from: Date())
        
        
    }
 
    
    func getSchedule(from: Date) -> [Activity] {
        
        //ordena projetos por data de conclusão / deadline
        
        //em uma visao otimista, determina o schedule a partir da data definida
        
        
        return []
        
    }

}
