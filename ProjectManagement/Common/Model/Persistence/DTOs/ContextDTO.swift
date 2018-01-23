//
//  ContextDTO.swift
//  Fooco
//
//  Created by Victor S Melo on 23/01/18.
//

import Foundation

protocol ContextDTO {
    var name: String { get set }
    var projects: Set<Project>? { get set }
    var color: UIColor { get set }
}
