//
//  SignInViewController.swift
//  QuizApp
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var ViewSigninGoogle: UIView!
    @IBOutlet var ViewSigninFB: UIView!
    @IBOutlet var txtMobileNumber: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ViewSigninFB.addBorderShadow(shadowOpacity: 0.3, shadowRadius: 3.0, shadowColor: UIColor.black)
        ViewSigninGoogle.addBorderShadow(shadowOpacity: 0.3, shadowRadius: 3.0, shadowColor: UIColor.black)
        
        addDoneButtonTextField()
        
        txtPassword.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if(txtMobileNumber.text == "")
        {
            self.showAlert(title: "Alert", message: "Mobile Number cannot be Empty")
        }
        else if(txtPassword.text == "")
        {
            self.showAlert(title: "Alert", message: "Password cannot be Empty")
        }
        else
        {
            if !isvalidPhoneNumber(value: txtMobileNumber.text!)
            {
                self.showAlert(title: "Alert", message: "Mobile Number must of 10 digits")
            }
            else
            {
                
            }
            
        }
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "signUpViewController") as! SignUpViewController
        
        self.present(signUpViewController, animated: true, completion: nil)
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        
        txtMobileNumber.inputAccessoryView = doneToolbar
        
    }
    @objc func cancelPicker(){
        self.view.endEditing(true)
        
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
