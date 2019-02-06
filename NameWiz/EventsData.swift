//
//  Data.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-02.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import Foundation

class EventsData{
    
    static let instance = EventsData()
    
    private init () {
        if events.count == 0 {
            events = [Event("Sample Event")]
        }
    }

    
    var events: [Event] = []
    

}

