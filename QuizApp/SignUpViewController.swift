//
//  SignUpViewController.swift
//  QuizApp
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtContactNumber: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonTextField()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        
        if(txtFirstName.text == "")
        {
             self.showAlert(title: "Alert", message: "Please Enter First Name")
        }
        else if(txtLastName.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Last Name")
        }
        else if(txtEmail.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Email Address")
        }
        else if(txtContactNumber.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Contact Number")
        }
        else if(txtPassword.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter Password")
        }
        else
        {
            if !isValidEmail(testStr: txtEmail.text!)
            {
                self.showAlert(title: "Alert", message: "Please Enter Vaild Email Address")
            }
            else if  !isvalidPhoneNumber(value: txtContactNumber.text!)
            {
                self.showAlert(title: "Alert", message: "Mobile Number must of 10 digits")
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let verifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "verifyOTPViewController") as! VerifyOTPViewController
                
                self.present(verifyOTPViewController, animated: true, completion: nil)
            }
        }
        
    }
   
    
    @IBAction func EmailEditingBegin(_ sender: UITextField) {
        
        self.view.frame.origin.y =  self.view.frame.origin.y - 50
    }
    @IBAction func EmailEditingEnd(_ sender: UITextField) {
        self.view.frame.origin.y =  self.view.frame.origin.y + 50
    }
    @IBAction func ContactNumberEditingBegin(_ sender: UITextField) {
        self.view.frame.origin.y =  self.view.frame.origin.y - 150
    }
    @IBAction func ContactNumberEditingEnd(_ sender: UITextField) {
         self.view.frame.origin.y =  self.view.frame.origin.y + 150
    }
    @IBAction func PasswordEditingBegin(_ sender: UITextField) {
        self.view.frame.origin.y =  self.view.frame.origin.y - 200
    }
    @IBAction func PasswordEditingEnd(_ sender: UITextField) {
        self.view.frame.origin.y =  self.view.frame.origin.y + 200
    }
    
    func addDoneButtonTextField()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelPicker))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        txtContactNumber.inputAccessoryView = doneToolbar
        txtFirstName.inputAccessoryView = doneToolbar
        txtLastName.inputAccessoryView = doneToolbar
        txtEmail.inputAccessoryView = doneToolbar
        txtPassword.inputAccessoryView = doneToolbar
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
    
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            
            //if(nextField.tag == )
            
            nextField.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
            
            return true;
            
        }
        
        return false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
