//
//  EventVC.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-02.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import UIKit

class EventVC: UIViewController {

    weak var TabVC: TabViewController!
    var eventID: Int!
    var eventTitle: String {
        get { return EventsData.instance.events[eventID].eventTitle }
        set { EventsData.instance.events[eventID].eventTitle = newValue }
    }
    var contacts: [Contact]{
        get { return EventsData.instance.events[eventID].contacts }
        set { EventsData.instance.events[eventID].contacts = newValue }
    }
    
    var navBarTitleItem: UINavigationItem?
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navBarLongPressOutlet: UILongPressGestureRecognizer!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        if textfield.isEditing {
            self.view.endEditing(true)
        }
        if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
            navBar.popItem(animated: true)
        }
    }
    
    lazy var titleTextField = UITextField()
    
    @IBAction func navBarLongPressAction(_ sender: UILongPressGestureRecognizer) {
        let navItem = UINavigationItem(title: "New Event Name")
        if navBar.topItem == navBarTitleItem {
            titleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: navBar.frame.width * 0.5, height: navBar.frame.height * 0.9))
            titleTextField.borderStyle = .roundedRect
            titleTextField.backgroundColor = UIColor.white
            titleTextField.placeholder = "Edit Event Name"
            titleTextField.textAlignment = .center
            
            let attributes = navBar.titleTextAttributes!
            titleTextField.font = attributes[.font] as? UIFont
            
            navItem.titleView = titleTextField
            
            navBar.pushItem(navItem, animated: true)
            print("triggered")
            titleTextField.delegate = self
            titleTextField.becomeFirstResponder()
        }
    }
    
    func addNewContact(_ name: String) {
        let indexOfSpace = name.lastIndex(of: " ")
        var firstName: String
        var lastName: String
        var newContact: Contact
        if let index = indexOfSpace {
            firstName = String(name[..<index])
            lastName = String(name[index...].dropFirst())
            newContact = Contact(firstName, lastName)
        } else {
          firstName = name
            newContact = Contact(firstName)
        }
        EventsData.instance.events[eventID].contacts.append(newContact)
        Disk.saveData()
        
        tableView.reloadData()
    }
//    
//    static let ReloadOptionsKey = "ReloadOptions"
//    static let EventIDKey = "EventID"
//    enum ReloadOptions {
//        case ReloadTabButtons
//        case ReloadTabVCs
//        case GotoLastVC
//    }
//    
    func changeEventName(_ name: String) {
        EventsData.instance.events[eventID].eventTitle = name
        navBarTitleItem?.title = name
        Disk.saveData()
        TabVC.reloadData()
        TabVC.scrollToPage(.at(index: eventID), animated: false)
//        NotificationCenter.default.post(name: .ReloadTabViewController, object: self, userInfo: [EventVC.ReloadOptionsKey: [ReloadOptions.ReloadTabButtons]])
        
    }
    
    @IBAction func addNewEventAction(_ sender: UIBarButtonItem) {
        EventsData.instance.events.append(Event("New Event"))
        Disk.saveData()
        TabVC.loadEventVCs()
        TabVC.scrollToPage(.last, animated: true)
//        NotificationCenter.default.post(name: .ReloadTabViewController, object: self, userInfo: [EventVC.ReloadOptionsKey: [ReloadOptions.GotoLastVC, ReloadOptions.ReloadTabVCs]])
    }
    
//    @IBAction func clearDataAction(_ sender: UIBarButtonItem) {
//        EventsData.instance.events = [Event("Sample Event")]
//        Disk.saveData()
//        NotificationCenter.default.post(name: .ReloadTabViewController, object: self, userInfo: [EventVC.ReloadOptionsKey: [ReloadOptions.ReloadTabVCs]])
//    }
    
    override func viewDidLoad() {
//        // TESTCODE
//        eventID = 0
        
        tableView.reloadData()
        
        navBarTitleItem = navBar.topItem
        navBarTitleItem?.title = eventTitle
        
        navBar.barTintColor = UIColor.lightGray
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        
        
        tableView.delegate = self
        textfield.delegate = self
        
        super.viewDidLoad()
    }
    

}

extension EventVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        var fullName: String
        fullName = contacts[indexPath.row].firstName
        
        if (contacts[indexPath.row].lastName != "") {
          fullName += " \(contacts[indexPath.row].lastName)"
        }
        cell.textLabel?.text = fullName
        cell.textLabel?.font = Customisation.Font.NoteWorthy
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            Disk.saveData()
        }
    }
    
}

extension EventVC: UITextFieldDelegate {
    // if textfield is adding new person textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfield {
            if let text = textField.text {
                if text != ""{
                    addNewContact(text)
                }
            }
            textField.text = ""
            
        // if textfield is changing event name textfield
        } else if textField == titleTextField, let text = textField.text, text != "" {
            changeEventName(text)
            navBar.popItem(animated: true)
            self.view.endEditing(true)
        }
        
        return false
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
}
