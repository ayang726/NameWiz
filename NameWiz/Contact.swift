//
//  Contact.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-02.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import Foundation

class Contact: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: Constants.Coder.FirstNameKey)
        aCoder.encode(lastName, forKey: Constants.Coder.LastNameKey)
        aCoder.encode(facts, forKey: Constants.Coder.Facts)
        aCoder.encode(conversation, forKey: Constants.Coder.Conversation)
        aCoder.encode(phoneNumber, forKey: Constants.Coder.PhoneNumber)
        aCoder.encode(email, forKey: Constants.Coder.Email)
        aCoder.encode(birthday, forKey: Constants.Coder.Birthday)
        aCoder.encode(notes, forKey: Constants.Coder.Notes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        firstName = aDecoder.decodeObject(forKey: Constants.Coder.FirstNameKey) as! String
        lastName = aDecoder.decodeObject(forKey: Constants.Coder.LastNameKey) as! String
        facts = aDecoder.decodeObject(forKey: Constants.Coder.Facts) as! String
        conversation = aDecoder.decodeObject(forKey: Constants.Coder.Conversation) as! String
        phoneNumber = aDecoder.decodeObject(forKey: Constants.Coder.PhoneNumber) as! String
        email = aDecoder.decodeObject(forKey: Constants.Coder.Email) as! String
        birthday = aDecoder.decodeObject(forKey: Constants.Coder.Birthday) as? Date
        notes = aDecoder.decodeObject(forKey: Constants.Coder.Notes) as! String
    }
    
    
    var firstName: String
    var lastName: String = ""
    var facts: String = ""
    var conversation: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var birthday: Date?
    var notes: String = ""
    
    init(_ firstName: String) {
        self.firstName = firstName
    }
    init(_ firstName: String, _ lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    
}
