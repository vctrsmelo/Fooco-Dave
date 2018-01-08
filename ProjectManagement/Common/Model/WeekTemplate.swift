//
//  WeekTemplate.swift
//  FoocoNewArchitecture
//
//  Created by Victor S Melo on 28/12/17.
//  Copyright © 2017 Victor S Melo. All rights reserved.
//

import Foundation

struct WeekTemplate {
    
    // swiftlint:disable:next large_tuple
    var value: (WeekdayTemplate, WeekdayTemplate, WeekdayTemplate, WeekdayTemplate, WeekdayTemplate, WeekdayTemplate, WeekdayTemplate)

    init(sun val0: WeekdayTemplate, mon val1: WeekdayTemplate, tue val2: WeekdayTemplate, wed val3: WeekdayTemplate, thu val4: WeekdayTemplate, fri val5: WeekdayTemplate, sat val6: WeekdayTemplate) {
        value.0 = val0
        value.1 = val1
        value.2 = val2
        value.3 = val3
        value.4 = val4
        value.5 = val5
        value.6 = val6
    }
    
    var iterableValue: [WeekdayTemplate] {
        return [value.0, value.1, value.2, value.3, value.4, value.5, value.6]
    }
    
}
