//
//  ContactDetailsVC.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-10.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import UIKit

class ContactDetailsVC: UIViewController, UIGestureRecognizerDelegate {

    weak var contact: Contact!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func saveBarSaveAction(_ sender: UIBarButtonItem) {
    }
    @IBAction func navBarDoneAction(_ sender: UIBarButtonItem) {
        Disk.saveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    var scrollViewOriginalHeight: CGFloat!
    
    
    @IBOutlet weak var firstNameTextFieldOutlet: UITextField!
    @IBOutlet weak var lastNameTextFieldOutlet: UITextField!
    @IBOutlet weak var companyTextFieldOutlet: UITextField!
    @IBOutlet weak var titleTextFieldOutlet: UITextField!
    
    @IBOutlet weak var thingsToRememberLabel: UILabel!
    @IBOutlet weak var conversationLabel: UILabel!
    @IBOutlet weak var thingsToRememberTextViewOutlet: UITextView!
    @IBOutlet weak var ConversationTextViewOutlet: UITextView!
    
    
    @IBOutlet weak var phoneNumberTextFieldOutlet: UITextField!
    
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    
    var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var birthdayTextFieldOutlet: UITextField!
    
    @IBOutlet weak var notesTextViewOutlet: UITextView!
    
    @IBOutlet var textFieldOutletCollection: [UITextField]!
    @IBOutlet var textViewOutletCollection: [UITextView]!
    
    
    @IBOutlet weak var tapOutlet: UITapGestureRecognizer!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        let possibleFirstResponders = textFieldOutletCollection as [UIView] + textViewOutletCollection as [UIView]
        for view in possibleFirstResponders {
            if view.isFirstResponder {
                view.resignFirstResponder()
                view.removeGestureRecognizer(tapOutlet)
            }
        }
        datePicker.removeFromSuperview()
    }
    
    func updateDynamicLabels(firstName: String) {
        thingsToRememberLabel.text = "Things to remember about \(firstName):"
        conversationLabel.text = "\(firstName) said:"
        navBar.topItem?.title = firstName
    }
    
    
    func addDatePicker() {
        let datePickerHeight: CGFloat = 150
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: (view.frame.height - datePickerHeight - 50), width: view.frame.width, height: datePickerHeight))
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
        datePicker.backgroundColor = UIColor.lightGray
        
        view.addSubview(datePicker)
    }
    
    @objc func changeDate(_ sender: UIDatePicker) {
        let date = dateFormatter.string(from: sender.date)
        birthdayTextFieldOutlet.text = date
        contact.birthday = date
    }
    
    override func viewDidLoad() {
        scrollViewOriginalHeight = scrollView.frame.height

        super.viewDidLoad()
        firstNameTextFieldOutlet.delegate = self
        lastNameTextFieldOutlet.delegate = self
        companyTextFieldOutlet.delegate = self
        titleTextFieldOutlet.delegate = self
        thingsToRememberTextViewOutlet.delegate = self
        ConversationTextViewOutlet.delegate = self
        phoneNumberTextFieldOutlet.delegate = self
        emailTextFieldOutlet.delegate = self
        birthdayTextFieldOutlet.delegate = self
        notesTextViewOutlet.delegate = self
        
        scrollView.delegate = self
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
//
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect)?.size {
//            if scrollView.frame.height
//                == scrollViewOriginalHeight{
//                scrollView.frame.size.height -= keyboardSize.height
//            }
//        }
//
//    }
//    
//    @objc func keyboardWillHide(_ notification: Notification) {
//        if scrollView.frame.height
//            != scrollViewOriginalHeight{
//            scrollView.frame.size.height = scrollViewOriginalHeight
//        }
//    }
    
    func updateUI() {
        updateDynamicLabels(firstName: contact.firstName)
        firstNameTextFieldOutlet.text = contact.firstName
        lastNameTextFieldOutlet.text = contact.lastName
        companyTextFieldOutlet.text = contact.company
        titleTextFieldOutlet.text = contact.title
        thingsToRememberTextViewOutlet.text = contact.facts
        ConversationTextViewOutlet.text = contact.conversation
        phoneNumberTextFieldOutlet.text = contact.phoneNumber
        emailTextFieldOutlet.text = contact.email
        birthdayTextFieldOutlet.text = contact.birthday
        notesTextViewOutlet.text = contact.notes
    }
}

extension ContactDetailsVC: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view.addGestureRecognizer(tapOutlet)
        if textField == birthdayTextFieldOutlet {
            addDatePicker()
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextFieldOutlet:
            lastNameTextFieldOutlet.becomeFirstResponder()
        case lastNameTextFieldOutlet:
            companyTextFieldOutlet.becomeFirstResponder()
        case companyTextFieldOutlet:
            titleTextFieldOutlet.becomeFirstResponder()
        case titleTextFieldOutlet:
            thingsToRememberTextViewOutlet.becomeFirstResponder()
        case phoneNumberTextFieldOutlet:
            emailTextFieldOutlet.becomeFirstResponder()
        case emailTextFieldOutlet:
            birthdayTextFieldOutlet.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextFieldOutlet:
            if firstNameTextFieldOutlet.text != "", firstNameTextFieldOutlet.text != nil {
                contact.firstName = firstNameTextFieldOutlet.text!
            }
        case lastNameTextFieldOutlet:
            contact.lastName = lastNameTextFieldOutlet.text ?? ""
        case companyTextFieldOutlet:
            contact.company = companyTextFieldOutlet.text ?? ""
        case titleTextFieldOutlet:
            contact.title = titleTextFieldOutlet.text ?? ""
        case phoneNumberTextFieldOutlet:
            contact.phoneNumber = phoneNumberTextFieldOutlet.text ?? ""
        case emailTextFieldOutlet:
            contact.email = emailTextFieldOutlet.text ?? ""
        default:
            break
        }
        updateUI()
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        view.addGestureRecognizer(tapOutlet)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
        switch textView {
        case thingsToRememberTextViewOutlet:
            contact.facts = thingsToRememberTextViewOutlet.text ?? ""
        case ConversationTextViewOutlet:
            contact.conversation = ConversationTextViewOutlet.text ?? ""
        case notesTextViewOutlet:
            contact.notes = notesTextViewOutlet.text ?? ""
        default:
            break
        }
    }
    

}

extension ContactDetailsVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    
}
