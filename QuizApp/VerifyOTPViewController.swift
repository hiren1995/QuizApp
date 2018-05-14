//
//  VerifyOTPViewController.swift
//  QuizApp
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


class VerifyOTPViewController: UIViewController {

    @IBOutlet var txtOTP: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonTextField()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnVerify(_ sender: UIButton) {
        
        verifyOTP()
    }
    
    func verifyOTP()
    {
        if(txtOTP.text == "")
        {
            self.showAlert(title: "Alert", message: "Please Enter OTP")
            
        }
        else
        {
            let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let VerifyOTPParameters:Parameters = ["user_contact_no": userdefault.value(forKey: contactNoToVerify) as! String, "verification_code" : txtOTP.text! ]
            
            print(VerifyOTPParameters)
            
            Alamofire.request(verifyUserAPI, method: .post, parameters: VerifyOTPParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if(response.result.value != nil)
                {
                    Spinner.hide(animated: true)
                    
                    print(JSON(response.result.value))
                    
                    let tempDict = JSON(response.result.value!)
                    
                    if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 1)
                    {
                        
                        userdefault.set(true, forKey: isLogin)
                        
                        userdefault.set(tempDict["user_data"][0]["user_id"].intValue, forKey: userId)
                        userdefault.set(tempDict["user_data"][0]["user_token"].intValue, forKey: userToken)
                       
                        userdefault.set(response.result.value, forKey: userData)
                        
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
                        self.present(slideViewController, animated: true, completion: nil)
                        
                        
                    }
                    else if(tempDict["status"] == "failure")
                    {
                        self.showAlert(title: "Alert", message: "OTP not Verified")
                    }
                    
                }
                else
                {
                    Spinner.hide(animated: true)
                    self.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
                }
            })
        }
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
        
        txtOTP.inputAccessoryView = doneToolbar
        
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
