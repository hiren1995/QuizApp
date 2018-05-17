//
//  CustomClass.swift
//  QuizApp
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UIView {
    
    @IBInspectable var ViewborderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var ViewcornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var ViewborderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}



extension UIApplication {
    class var setStatusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
            
        }
    }
}


extension UIView
{
    func addBorderShadow(shadowOpacity : Float , shadowRadius : CGFloat , shadowColor : UIColor)
    {
        self.layer.shadowOffset = CGSize.zero
        //self.layer.shadowOpacity = 0.3
        //self.layer.shadowRadius = 3.0
        //self.layer.shadowColor = UIColor.black.cgColor
        
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
    }
}

extension UIViewController
{
    func showAlert(title : String , message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel , handler: nil))
        
        self.present(alert, animated: true, completion: nil)

        /*
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) {
            UIAlertAction in
        
            print("Cancelled")
            
        })
        */
    }
    
}

func isvalidPhoneNumber(value: String) -> Bool {
    let PHONE_REGEX = "^\\d{10}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func getTimeFromDate(datestr : String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    print(datestr)
    let date = dateFormatter.date(from: datestr)
    
    print(date)
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm"
    let timestr = timeFormatter.string(from: date!)
    
    return timestr
    
}

