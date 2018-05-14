//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation

var tempLatitude:Double?
var tempLongitude:Double?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate{

    var window: UIWindow?

    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        getLatLong()
        
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func Authenticate()
    {
        
         let Login = UserDefaults.standard.bool(forKey: isLogin)
         
         if Login{
         
            let initialView = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
            self.window?.rootViewController = initialView
         }
        
    }
    
    func getLatLong()
    {
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        let x = locationManager.location
        print(x?.coordinate.latitude)
        print(x?.coordinate.longitude)
        
        tempLatitude = x?.coordinate.latitude
        tempLongitude = x?.coordinate.longitude
        
        Authenticate()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let mylocation = locations.last
        
        
        //mylocation!.coordinate.latitude, mylocation!.coordinate.longitude
        
        tempLatitude = mylocation!.coordinate.latitude.magnitude
        tempLongitude = mylocation!.coordinate.longitude.magnitude
        
        print(tempLatitude)
        print(tempLongitude)
        
        locationManager.stopUpdatingLocation()
        
        //Authenticate()
        
    }
    
    
    
    /*
    func Authenticate()
    {
        
        let Login = UserDefaults.standard.bool(forKey: isLogin)
        
        if Login{
            
            //if let fcmToken = UserDefaults.standard.value(forKey: DeviceToken)
            //{
                //for version 1 the fcm token is nil so it would crash when we need to get fcm token from userdefault so this code helps in saving app from crashing..!
                
                //print(fcmToken)
                
                //let loginParameters:Parameters = ["email": udefault.value(forKey: EmailAddress)! , "password" : udefault.value(forKey: Password)! , "device_token" : "" , "device_type" : 2]
               let SigninParameters:Parameters = userdefault.value(forKey: LoginParameters) as! Parameters
                print(SigninParameters)
                
                Alamofire.request(signinAPI, method: .post, parameters: SigninParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    if(response.result.value != nil)
                    {
                        
                        print(JSON(response.result.value))
                        
                        let tempDict = JSON(response.result.value!)
                        
                        //print(tempDict["data"]["user_id"])
                        
                        if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 1)
                        {
                            userdefault.set(response.result.value, forKey: userData)
                            
                        }
                        else if(tempDict["status"] == "error")
                        {
                            self.window?.rootViewController?.showAlert(title: "Alert", message: "Invalid Email or Password")
                            let initialView = self.storyboard.instantiateViewController(withIdentifier: "signInViewController") as! SignInViewController
                            self.window?.rootViewController = initialView
                        }
                        
                    }
                    else
                    {
                        self.window?.rootViewController?.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
                        
                    }
                })
           // }
           //else
           // {
           //     print("nil")
           //     let initialView = self.storyboard.instantiateViewController(withIdentifier: "signIn") as! SignIn
           //     self.window?.rootViewController = initialView
           // }
            
            
            
        }
        else
        {
            let initialView = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.window?.rootViewController = initialView
        }
 
 
    }
    */
}

