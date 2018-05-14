//
//  SignInViewController.swift
//  QuizApp
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

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
                
                let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let SigninParameters:Parameters = ["user_name":"","user_contact_no": txtMobileNumber.text!,"user_email" :  "" , "user_password" : txtPassword.text!,"user_profile_photo":"","user_device_type":2,"user_device_token":"123456","user_lat":tempLatitude,"user_long":tempLongitude,"user_signin":1]
                
                print(SigninParameters)
                
                Alamofire.request(signinAPI, method: .post, parameters: SigninParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if(response.result.value != nil)
                    {
                        Spinner.hide(animated: true)
                        
                        print(JSON(response.result.value))
                        
                        let tempDict = JSON(response.result.value!)
                        
                        if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 1)
                        {
                            userdefault.set(true, forKey: isLogin)
                            
                            userdefault.set(tempDict["login_user"][0]["user_id"].intValue, forKey: userId)
                            userdefault.set(tempDict["login_user"][0]["user_token"].intValue, forKey: userToken)
                            
                            userdefault.set(response.result.value, forKey: userData)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
                            
                            self.present(slideViewController, animated: true, completion: nil)
 
                            
                            
                        }
                        else if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 2)
                        {
                            let alert = UIAlertController(title: "OTP Sent Successfully", message: "Please Verify Mobile Number as you are already registered from this mobile number", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let verifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "verifyOTPViewController") as! VerifyOTPViewController
                                
                                self.present(verifyOTPViewController, animated: true, completion: nil)
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                            
                        else if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 3)
                        {
                            self.showAlert(title: "Alert", message: tempDict["message"].stringValue)
                        }
                        else
                        {
                            self.showAlert(title: "Alert", message: "Invalid Credentials")
                        }
                        
                    }
                    else
                    {
                        Spinner.hide(animated: true)
                        self.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
                    }
                })
                
                
                
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                //let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
                
                //self.present(slideViewController, animated: true, completion: nil)
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
