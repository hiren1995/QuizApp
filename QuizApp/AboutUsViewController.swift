//
//  AboutUsViewController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Alamofire
import SwiftyJSON
import MBProgressHUD

class AboutUsViewController: UIViewController {

    @IBOutlet var textAboutUs: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //loadData()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        
        
        let slidemenu = self.slideMenuController()
        
        slidemenu?.openLeft()
        
    }
    
    func loadData()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parameters : Parameters = [:]
        
        
        Alamofire.request(aboutUsDetailsAPI, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                let tempDict = JSON(response.result.value!)
                
                
                if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 1)
                {
                    self.textAboutUs.text = tempDict["about_us_details"][0]["about_us_description"].stringValue
                    
                }
        
                else
                {
                    self.showAlert(title: "Alert", message: "Something went wrong")
                }
 
            }
            else
            {
                Spinner.hide(animated: true)
                self.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
            }
        })
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
