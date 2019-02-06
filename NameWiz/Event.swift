//
//  Event.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-04.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import Foundation
class Event: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(eventTitle, forKey: Constants.Coder.EventTitle)
        aCoder.encode(contacts, forKey: Constants.Coder.Contacts)
    }
    
    required init?(coder aDecoder: NSCoder) {
        eventTitle = aDecoder.decodeObject(forKey: Constants.Coder.EventTitle) as! String
        contacts = aDecoder.decodeObject(forKey: Constants.Coder.Contacts) as! [Contact]
    }
    
    var eventTitle: String
    var contacts: [Contact] = []
    
    init(_ eventTitle: String) {
        self.eventTitle = eventTitle
    }
    init(_ eventTitle: String, contacts: [Contact]) {
        self.eventTitle = eventTitle
        self.contacts = contacts
    }
    
    
}
