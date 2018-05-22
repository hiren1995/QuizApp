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

class AboutUsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var textAboutUs: UITextView!
    @IBOutlet var AboutUsTableView: UITableView!
    
    var aboutUsDict = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AboutUsTableView.delegate = self
        AboutUsTableView.dataSource = self
        
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
                    //self.textAboutUs.text = tempDict["about_us_details"][0]["about_us_description"].stringValue
                    
                    self.AboutUsTableView.reloadData()
                    
                    self.aboutUsDict = tempDict
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
    @IBAction func btnRefresh(_ sender: UIButton) {
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            let cell = Bundle.main.loadNibNamed("AboutUsFirstIndexTableViewCell", owner: self, options: nil)?.first as! AboutUsFirstIndexTableViewCell
            
            
            
            return cell
        }
        else if(indexPath.row == 1)
        {
            let cell = Bundle.main.loadNibNamed("AboutUsSecondIndexTableViewCell", owner: self, options: nil)?.first as! AboutUsSecondIndexTableViewCell
            
            cell.lblAbouUsText.text = self.aboutUsDict["about_us_details"][0]["about_us_description"].stringValue
            
            return cell
        }
        else
        {
            let cell = Bundle.main.loadNibNamed("AboutUsThirdIndexTableViewCell", owner:
                self, options: nil)?.first as! AboutUsThirdIndexTableViewCell
            
            cell.btnMobileNo.addTarget(self, action: #selector(doCall), for: .touchUpInside)
            cell.btnEmail.addTarget(self, action: #selector(doMail), for: .touchUpInside)
            cell.btnWebsite.addTarget(self, action: #selector(openURL), for: .touchUpInside)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == 0)
        {
            return 190
        }
        else if(indexPath.row == 1)
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            return 186
        }
        
    }
    
    @objc func doCall()
    {
        let alert = UIAlertController(title: "Make Call", message: "Are you sure you want to make Call", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
            let contact = "+912242978084"
            if let url = URL(string: "tel://\(contact)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func doMail()
    {
        
        let email = "contact@adwebtech.com"
        if let url = URL(string: "mailto:\(email)")
        {
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url)
            }
            else
            {
                UIApplication.shared.openURL(url)
                
            }
        }
       
        
    }
    
    @objc func openURL()
    {
        let alert = UIAlertController(title: "Open Website", message: "Are you sure you want to open Website", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
            if let url = URL(string: "https://www.adwebtech.com")  {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
       
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
