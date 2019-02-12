//
//  EventVC.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-02.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import UIKit
import Tabman

class EventVC: UIViewController {

    weak var TabVC: TabViewController!
    var eventID: Int!
    lazy var eventTitle = eventsInstance.getEventTitle(for: eventID)
    
    private let eventsInstance = EventsData.instance
    private var contacts: [Contact] { return eventsInstance.getContact(for: eventID)}
    
    private var navBarTitleItem: UINavigationItem?
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navBarLongPressOutlet: UILongPressGestureRecognizer!
    
    @IBOutlet weak var tableView: UITableView!
    var tableViewOriginalY: CGFloat!
    
    @IBOutlet weak var tapOutlet: UITapGestureRecognizer!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        if textfield.isEditing {
            self.view.endEditing(true)
        }
        if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
            navBar.popItem(animated: true)
        }
        view.removeGestureRecognizer(tapOutlet)
    }
    
    private var titleTextField = UITextField()
    
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
            titleTextField.delegate = self
            titleTextField.becomeFirstResponder()
        }
    }
    
    func addNewContact(_ name: String) {
        let indexOfSpace = name.lastIndex(of: " ")
        var firstName = ""
        var lastName = ""
        if let index = indexOfSpace {
            firstName = String(name[..<index])
            lastName = String(name[index...].dropFirst())
        } else {
          firstName = name
        }
        
        eventsInstance.addContact(firstName: firstName, lastName: lastName, toEvent: eventID)
        
        tableView.reloadData()
    }
   
    func changeEventName(_ name: String) {
        eventsInstance.setEventTitle(name, for: eventID)
        navBarTitleItem?.title = name
        TabVC.reloadData()
        TabVC.scrollToPage(.at(index: eventID), animated: false)
    }
    
    @IBAction func addNewEventAction(_ sender: UIBarButtonItem) {
        eventsInstance.addEvent()
        TabVC.loadEventVCs()
        TabVC.scrollToPage(.last, animated: true)
    }
    
    override func viewDidLoad() {
        tableViewOriginalY = tableView.frame.origin.y
        super.viewDidLoad()
        
        navBarTitleItem = navBar.topItem
        navBarTitleItem?.title = eventsInstance.getEventTitle(for: eventID)
        
        navBar.barTintColor = UIColor.lightGray
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        textfield.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect)?.size {
//            if tableView.frame.origin.y
//                == tableViewOriginalY{
//                tableView.frame.origin.y -= keyboardSize.height
//            }
//        }
//
//    }
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//        if tableView.frame.origin.y
//            != tableViewOriginalY{
//            tableView.frame.origin.y = tableViewOriginalY
//        }
//    }
}

extension EventVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.ContactCellIdentifier, for: indexPath) as! ContactsTableViewCell
        
        let contact = contacts[indexPath.row]
        
        // parse primary info: Name (Title, Company)
        var fullName: String
        fullName = contact.firstName
        
        if (contact.lastName != "") {
          fullName += " \(contact.lastName)"
        }
        
        let title = contact.title
        let company = contact.company
        
        var primaryInfo = fullName
        if title != "" && company != ""{
            primaryInfo += " (\(title), \(company))"
            
        } else if title == "" && company == "" {
            primaryInfo += ""
        } else {
            primaryInfo += "(\(title + company))"
        }
        
        // Parse secondary info: things to remember | conversation | notes
        let facts = contact.facts
        let conversation = contact.conversation
        let notes = contact.notes
        
        var secondaryInfo = facts
        if conversation != "" {
            secondaryInfo += " | \(conversation)"
        }
        if notes != "" {
            secondaryInfo += " | \(notes)"
        }
        
        cell.primaryInfoLable.text = primaryInfo
        cell.secondaryInfoLabel.text = secondaryInfo

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let _ = eventsInstance.removeContact(forEvent: eventID, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            Disk.saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Identifiers.GoToDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.GoToDetails, let destination = segue.destination as? ContactDetailsVC, let index = tableView.indexPathForSelectedRow?.row {
            destination.contact = contacts[index]
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addGestureRecognizer(tapOutlet)
    }
}
