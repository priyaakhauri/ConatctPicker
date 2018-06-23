//
//  Contactdetails.swift
//  ContactDemoApp
//
//  Created by Ankur Akhauri on 23/06/18.
//  Copyright © 2018 DemoApp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Contactdetails : UIViewController, UITextFieldDelegate
{
    
   
    @IBOutlet weak var firstNameTextVar: UITextField!
    @IBOutlet weak var secondNameTextVar: UITextField!
    @IBOutlet weak var emailTextVar: UITextField!
    @IBOutlet weak var phoneNumVar: UITextField!
    @IBOutlet weak var countryNameTextVar: UITextField!
    var keyboradHideforEditNoteVarRem : UIBarButtonItem!
    var appDel : AppDelegate? = nil
    
    
    @IBAction func saveContactDetailsFunc(_ sender: UIButton) {
        
        appDel = UIApplication.shared.delegate as? AppDelegate
        
        guard let _context = appDel?.managedObjectContext else { return }
        
        // Using the Managed Object Context, lets create a new entry into entity "Task"
        let object = NSEntityDescription.insertNewObject(forEntityName: "ContactDetails", into:_context) as! ContactDetails
        object.firstname = firstNameTextVar.text
        object.secondname = secondNameTextVar.text
        object.email = emailTextVar.text
        object.phone = phoneNumVar.text
        object.country = countryNameTextVar.text
        object.completed = false
        
        appDel?.saveContext()
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.firstNameTextVar {
            self.secondNameTextVar.becomeFirstResponder()
        }else if textField == self.secondNameTextVar{
            self.emailTextVar.becomeFirstResponder()
        }else if textField == self.emailTextVar{
            self.phoneNumVar.becomeFirstResponder()
        }else if textField == self.phoneNumVar{
            self.countryNameTextVar.becomeFirstResponder()
        }else{
            self.firstNameTextVar.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem = self.keyboradHideforEditNoteVarRem
        print("TextField did begin editing method called")
    }
    
    @IBAction func hideKeyboardBtnFunc(_ sender: Any) {
        if(self.navigationItem.rightBarButtonItem != nil) {
            keyboradHideforEditNoteVarRem = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = nil
        }
         self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
            if(self.navigationItem.rightBarButtonItem != nil) {
            keyboradHideforEditNoteVarRem = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextVar.delegate = self
        secondNameTextVar.delegate = self
        emailTextVar.delegate = self
        phoneNumVar.delegate = self
        countryNameTextVar.delegate = self
        
        
    }
}
