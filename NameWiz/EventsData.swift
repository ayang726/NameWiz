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

    
    private var events: [Event] = []
    var eventsCount: Int {return events.count}
    
    
    func loadData() {
        events = Disk.retrieve(Constants.FileNames.EventsData, from: .documents)
    }
    
    func getContact(for eventIndex: Int) -> [Contact]{
        return events[eventIndex].contacts
    }
    func addContact(_ contact: Contact, toEvent index: Int) {
        events[index].contacts.append(contact)
        Disk.saveData()
    }
    func addContact(firstName: String, lastName: String = "", toEvent index: Int) {
        let contact = Contact(firstName, lastName)
        addContact(contact, toEvent: index)
    }
    func removeContact(forEvent eventIndex: Int, at index: Int) -> Contact {
        let contact = events[eventIndex].contacts.remove(at: index)
        Disk.saveData()
        return contact
    }
    
    func setEventTitle(_ title:String, for eventIndex: Int) {
        events[eventIndex].eventTitle = title
        Disk.saveData()
    }
    func getEventTitle(for index: Int) -> String {
        return events[index].eventTitle
    }
    func getAllEvents() -> [Event] {
        return events
    }
    func addEvent() {
        events.append(Event("New Event"))
        Disk.saveData()
    }
    func removeEvent(at index: Int) -> Event {
        let event = events.remove(at: index)
        Disk.saveData()
        return event
    }
    func removeAll() {
        events.removeAll()
        addEvent()
    }

}

