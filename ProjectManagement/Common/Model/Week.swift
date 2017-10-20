//
//  Week.swift
//  Fooco
//
//  Created by Victor S Melo on 19/10/17.
//  Copyright © 2017 Victor Melo. All rights reserved.
//

import Foundation

struct Week {
    
    var monday: Weekday
    var tuesday: Weekday
    var wednesday: Weekday
    var thursday: Weekday
    var friday: Weekday
    var saturday: Weekday
    var sunday: Weekday
    
    /**
     Return the repective weekday.
     - Parameters:
         - val: the number of the weekday. 1 is monday, 7 is sunday.
     */
    func getDay(_ val: Int) -> Weekday? {
        switch val {
            case 1:
                return monday
            case 2:
                return tuesday
            case 3:
                return wednesday
            case 4:
                return thursday
            case 5:
                return friday
            case 6:
                return saturday
            case 7:
                return sunday
            default:
                return nil
        }
        
    }
    
    init() {
        monday = Weekday()
        tuesday = Weekday()
        wednesday = Weekday()
        thursday = Weekday()
        friday = Weekday()
        saturday = Weekday()
        sunday = Weekday()
    }
    
}
