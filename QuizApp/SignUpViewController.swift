//
//  SignUpViewController.swift
//  QuizApp
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CropViewController
import CoreLocation

class SignUpViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate,CLLocationManagerDelegate {

    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtContactNumber: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    let locationManager = CLLocationManager()
    
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonTextField()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        latitude = locValue.latitude
        longitude = locValue.longitude
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
            else if(imgProfilePic.image == UIImage(named: "dummy"))
            {
                 self.showAlert(title: "Alert", message: "Please Select Profile Pic for your Account")
            }
            else
            {
                let imgData = UIImageJPEGRepresentation(imgProfilePic.image!, 0.1)
                
                let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let updateParameters:Parameters = ["user_name": txtFirstName.text! + txtLastName.text! , "user_contact_no" : txtContactNumber.text! , "user_email" : txtEmail.text! , "user_device_type" : 2 , "user_device_id" : "123", "user_device_token" : "abcd1234" , "user_lat" : latitude , "user_long" : longitude , "user_signin": 1 ,"user_password" : txtPassword.text!]
                
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    
                    for (key, value) in updateParameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
                    if let data = imgData{
                        
                        multipartFormData.append(data, withName: "user_profile_photo", fileName: "image.jpg", mimeType: "image/jpg")
                        
                    }
                    
                },to: signupAPI, encodingCompletion: { (result) in
                    
                    switch result{
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print("Succesfully uploaded")
                            
                            print(response.result.value)
                            
                            spinnerActivity.hide(animated: true)
                            
                            let tempDict = JSON(response.result.value)
                            
                            if(tempDict["status"].stringValue == "success" && tempDict["status_code"].intValue == 1)
                            {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let verifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "verifyOTPViewController") as! VerifyOTPViewController
                                
                                self.present(verifyOTPViewController, animated: true, completion: nil)
                            }
                            else if(tempDict["status"].stringValue == "failure" && tempDict["status_code"].intValue == 0)
                            {
                                
                                let alert = UIAlertController(title: "User Already Registered", message: "Please Login as you are already registered from this mobile number", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    let signInViewController = storyboard.instantiateViewController(withIdentifier: "signInViewController") as! SignInViewController
                                    
                                    self.present(signInViewController, animated: true, completion: nil)
                                    
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            //let verifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "verifyOTPViewController") as! VerifyOTPViewController
                            
                            //self.present(verifyOTPViewController, animated: true, completion: nil)
                            
                        }
                    case .failure(let error):
                        print("Error in upload: \(error.localizedDescription)")
                        spinnerActivity.hide(animated: true)
                        self.showAlert(title: "Alert", message: "Error in Uploading")
                        
                    }
                    
                })
                
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                //let verifyOTPViewController = storyboard.instantiateViewController(withIdentifier: "verifyOTPViewController") as! VerifyOTPViewController
                
                //self.present(verifyOTPViewController, animated: true, completion: nil)
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
    @IBAction func btnAddPic(_ sender: UIButton) {
        
        ChangeProfilePic()
    }
    
    func ChangeProfilePic(){
        
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        var gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            //profileImg.image = image
            
            self.dismiss(animated: true, completion: nil)
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            present(cropViewController, animated: true, completion: nil)
            
            
        } else{
            print("Something went wrong")
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        imgProfilePic.image = image
        
        dismiss(animated: true, completion: nil)
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
