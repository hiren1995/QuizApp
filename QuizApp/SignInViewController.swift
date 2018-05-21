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

import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GoogleSignIn

import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()

class SignInViewController: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate{
   
   
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
        
        configureGoogleSignin()

        
        // Google Signin
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
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
                
                
                
                let SigninParameters:Parameters = ["user_name":"","user_contact_no": txtMobileNumber.text!,"user_email" :  "" , "user_password" : txtPassword.text!,"user_profile_photo":"","user_device_type":2,"user_device_id":userdefault.value(forKey: DeviceId)!,"user_device_token":userdefault.value(forKey: DeviceToken)!,"user_lat":tempLatitude!,"user_long":tempLongitude!,"user_signin":1]
                
                Signin(SignInParameters : SigninParameters)
                
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
    
    func configureGoogleSignin()
    {
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnGoogleSignin(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func Signin(SignInParameters : Parameters)
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        print(SignInParameters)
        
        Alamofire.request(signinAPI, method: .post, parameters: SignInParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                let tempDict = JSON(response.result.value!)
                
                if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 1)
                {
                    userdefault.set(true, forKey: isLogin)
                    
                    userdefault.set(tempDict["login_user"][0]["user_id"].stringValue, forKey: userId)
                    userdefault.set(tempDict["login_user"][0]["user_token"].stringValue, forKey: userToken)
                    
                    userdefault.set(response.result.value, forKey: userData)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
                    
                    self.present(slideViewController, animated: true, completion: nil)
                    
                    
                    
                }
                else if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 2)
                {
                    
                    userdefault.set(self.txtMobileNumber.text!, forKey: contactNoToVerify)
                    
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
        
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
                //print(user.profile.name)
                //print(user.profile.email)
                //print(user.profile.imageURL(withDimension: UInt(64)).relativeString)
        
            if(user != nil)
            {
                if(user.profile.name != nil)
                {
                    GoogleUserName = (user.profile.name)!
                }
                if(user.profile.email != nil)
                {
                    GoogleEmail = (user.profile.email)!
                }
                /*
                 if(user.profile. != nil)
                 {
                 GoogleUserContact = (user.phoneNumber)!
                 }
                 */
                if user.profile.hasImage
                {
                    GoogleProfilePic = user.profile.imageURL(withDimension: UInt(64)).relativeString
                }
                
                let GoogleSigninParameters:Parameters = ["user_name":GoogleUserName,"user_contact_no": GoogleUserContact,"user_email" :  GoogleEmail , "user_password" : "","user_profile_photo":GoogleProfilePic,"user_device_type":2,"user_device_id":userdefault.value(forKey: DeviceId)!,"user_device_token":userdefault.value(forKey: DeviceToken)!,"user_lat":tempLatitude!,"user_long":tempLongitude!,"user_signin":3]
                
                print(GoogleSigninParameters)
                
                self.Signin(SignInParameters : GoogleSigninParameters)
            }
                
        
        
    }
 
    @IBAction func btnFBLogin(_ sender: UIButton) {
        
       
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile","user_friends"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                print(result)
                
                // if user cancel the login
                if (result?.isCancelled)!{
                    
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")){
                    if((FBSDKAccessToken.current()) != nil){
                        
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                                //everything works print the user data
                                //print(FBSDKAccessToken.current().tokenString)
                                
                                let FBinfo = JSON(result)
                                print(FBinfo)
                                
                                if(FBinfo != JSON.null)
                                {
                                    let FBSigninParameters:Parameters = ["user_name":FBinfo["name"].stringValue ,"user_contact_no": "","user_email" :  FBinfo["email"].stringValue , "user_password" : "","user_profile_photo": FBinfo["picture"]["data"]["url"].stringValue,"user_device_type":2,"user_device_id":userdefault.value(forKey: DeviceId)!,"user_device_token":userdefault.value(forKey: DeviceToken)!,"user_lat":tempLatitude!,"user_long":tempLongitude!,"user_signin":3]
                                    
                                    print(FBSigninParameters)
                                    
                                    self.Signin(SignInParameters : FBSigninParameters)
                                }
                               
                            }
                        })
                        
                    }
                }
            }
        }
        
        
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
