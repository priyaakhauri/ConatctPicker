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
    //@IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var keyboardHeightLayoutConstrain: NSLayoutConstraint!
    
    
    
    @IBAction func saveContactDetailsFunc(_ sender: UIButton) {
        
        if(self.isValidEmail(testStr: emailTextVar.text!) == false)
        {
            let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.width, height: 100))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.red
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
            toastLabel.text = "email is not valid"
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 10.0, delay: 0.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
            return
        }
        
        if(self.validate(value: phoneNumVar.text!) == false)
        {
            let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.width, height: 100))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.red
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
            toastLabel.text = "Phone no is not valid"
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 10.0, delay: 0.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
            return
        }
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
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as?     NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstrain?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstrain?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        
        firstNameTextVar.delegate = self
        secondNameTextVar.delegate = self
        emailTextVar.delegate = self
        phoneNumVar.delegate = self
        countryNameTextVar.delegate = self
        
        
        
        
    }
}
