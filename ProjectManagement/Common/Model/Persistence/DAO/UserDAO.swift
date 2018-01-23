//
//  UserDAO.swift
//  Fooco
//
//  Created by Victor S Melo on 23/01/18.
//

import Foundation

protocol UserDAO {
    
    func save(_ user: User)
    func get() -> User
    
}

