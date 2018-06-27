//
//  Contactdetails.swift
//  ContactDemoApp
//
//  Created by Priya on 23/06/18.
//  Copyright © 2018 DemoApp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Contactdetails : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryInfo?.count ?? 0
    }
    
    var countryInfo : [[String:Any]]?
    var countryInfoUpdated :Bool = false
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var firstNameTextVar: UITextField!
    @IBOutlet weak var secondNameTextVar: UITextField!
    @IBOutlet weak var emailTextVar: UITextField!
    @IBOutlet weak var phoneNumVar: UITextField!
    @IBOutlet weak var countryNameTextVar: UITextField!
    var keyboradHideforEditNoteVarRem : UIBarButtonItem!
    var appDel : AppDelegate? = nil
    
    
    
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
            UIView.animate(withDuration: 5.0, delay: 0.5, options: .curveEaseOut, animations: {
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
            UIView.animate(withDuration: 5.0, delay: 0.5, options: .curveEaseOut, animations: {
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
        if(textField == countryNameTextVar){
            dropDown.isHidden = false
            textField.resignFirstResponder()
            
        }else{
            dropDown.isHidden = true
            self.navigationItem.rightBarButtonItem = self.keyboradHideforEditNoteVarRem
        }
        
        print("TextField did begin editing method called")
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(self.navigationItem.rightBarButtonItem != nil) {
            keyboradHideforEditNoteVarRem = self.navigationItem.rightBarButtonItem
            self.navigationItem.rightBarButtonItem = nil
        }
        textField.resignFirstResponder()
        return true
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
    
    func getCountryNames ()
    {
        let url = URL(string: "https://restcountries.eu/rest/v1/all")
        
        //JSON PARSING
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
                self.countryInfo = json
                let firstCountry = (self.countryInfo![0])["name"] as! String
                print(firstCountry)
                self.countryInfoUpdated = true

                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView
    {
        let countryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 20))
        countryLabel.text = countryInfo![row]["name"] as? String
        countryLabel.textColor = UIColor.brown
        countryLabel.textAlignment = NSTextAlignment.center
        return countryLabel
        
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int){
        let countryNameView = pickerView.view(forRow: row, forComponent: component) as! UILabel
        countryNameTextVar.text = countryNameView.text
         dropDown.isHidden = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         dropDown.isHidden = true
        getCountryNames ()
       
        while(countryInfoUpdated == false){ // wait for restful Api read
        }
        self.dropDown.reloadAllComponents()
        
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
