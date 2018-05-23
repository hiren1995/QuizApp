//
//  ForgetPasswordViewController.swift
//  QuizApp
//
//  Created by Apple on 23/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire

class ForgetPasswordViewController: UIViewController {

    @IBOutlet var txtMobileNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonTextField()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnSend(_ sender: UIButton) {
        
        if(txtMobileNo.text == "")
        {
            self.showAlert(title: "Contact Number", message: "Please Enter Contact Number")
        }
        else
        {
            if !isvalidPhoneNumber(value: txtMobileNo.text!)
            {
                self.showAlert(title: "Contact Number", message: "Please Enter 10 digit Vaild Contact Number")
            }
            else
            {
                let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let ForgetPasswordParameters:Parameters = ["user_contact_no":txtMobileNo.text!]
                
                print(ForgetPasswordParameters)
                
                Alamofire.request(ForgetPasswordAPI, method: .post, parameters: ForgetPasswordParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if(response.result.value != nil)
                    {
                        Spinner.hide(animated: true)
                        
                        print(JSON(response.result.value))
                        
                        
                        let temp = JSON(response.result.value!)
                        
                        if(temp["status"] == "success" && temp["status_code"].intValue == 1)
                        {
                            
                           self.dismiss(animated: true, completion: nil)
                        }
                        else if(temp["status"] == "failure" && temp["status_code"].intValue == 0)
                        {
                            
                             self.showAlert(title: "Alert", message: "Account Not Found With this Number.")
                        }
                        else
                        {
                            self.showAlert(title: "Alert", message: "Something Went wrong while sending Password. Please try again")
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
        
        txtMobileNo.inputAccessoryView = doneToolbar
        
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
