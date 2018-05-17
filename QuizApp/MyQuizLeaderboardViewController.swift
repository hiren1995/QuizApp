//
//  MyQuizLeaderboardViewController.swift
//  QuizApp
//
//  Created by Apple on 17/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import Kingfisher

class MyQuizLeaderboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var lblQuizName: UILabel!
    @IBOutlet var MyQuizLeaderboardTableView: UITableView!
    
    var QuizId = Int()
    
    var MyQuizLeaderBoard = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyQuizLeaderboardTableView.delegate = self
        MyQuizLeaderboardTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
          loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return 10
        
        return MyQuizLeaderBoard["quiz_result"].count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = MyQuizLeaderboardTableView.dequeueReusableCell(withIdentifier: "myQuizleaderboardTableViewCell", for: indexPath) as! MyQuizleaderboardTableViewCell
        
        cell.selectionStyle = .none
        
        if(MyQuizLeaderBoard != JSON.null && MyQuizLeaderBoard["quiz_result"].count != 0)
        {
            if(indexPath.row == 0)
            {
                cell.lblUserName.text = MyQuizLeaderBoard["user_data"][0]["user_name"].stringValue
                
                cell.lblLevel.isHidden = true
                
                cell.lblCompletionTime.text = MyQuizLeaderBoard["user_data"][0]["time_taken_to_finish"].stringValue
                
                cell.ViewCell.backgroundColor = UIColor(red: 221/255, green: 236/255, blue: 255/255, alpha: 1.0)
                
                if(MyQuizLeaderBoard["user_data"][0]["is_winner"].intValue == 1)
                {
                    cell.imgTrophy.isHidden = true
                    cell.lblWonLoose.text = "Sorry ,You have not answered of all questions correctly."
                    cell.lblWonLoose.textColor = UIColor.red
                }
                else
                {
                    var flag = 0
                    
                    for i in 0...MyQuizLeaderBoard["quiz_result"].count-1
                    {
                        if(MyQuizLeaderBoard["user_data"][0]["user_id"].intValue == MyQuizLeaderBoard["quiz_result"][i]["user_id"].intValue)
                        {
                            flag = 1
                            break
                        }
                    }
                    if(flag == 0)
                    {
                        cell.lblWonLoose.text = "Sorry ,You are not the fastest one."
                        cell.imgTrophy.isHidden = true
                        cell.lblWonLoose.textColor = UIColor.red
                    }
                    else
                    {
                        cell.lblWonLoose.text = "Congratulations!. You are Winner"
                        cell.lblWonLoose.textColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1.0)
                    }
                }
                
                KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: MyQuizLeaderBoard["user_data"][0]["user_profile_photo"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                    
                    
                    if(error == nil)
                    {
                        cell.imgUser.image = image
                        
                    }
                    else
                    {
                        self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
                    }
                    
                })
            }
            else
            {
                cell.lblUserName.text = MyQuizLeaderBoard["quiz_result"][indexPath.row - 1]["user_name"].stringValue
                cell.lblCompletionTime.text = MyQuizLeaderBoard["quiz_result"][indexPath.row - 1]["time_taken_to_finish"].stringValue
                cell.lblLevel.text = String(indexPath.row)
                cell.lblWonLoose.text = "Congratulations!. You are Winner"
                cell.lblWonLoose.textColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1.0)
                
                KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: MyQuizLeaderBoard["quiz_result"][indexPath.row - 1]["user_profile_photo"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                    
                    
                    if(error == nil)
                    {
                        cell.imgUser.image = image
                        
                    }
                    else
                    {
                        self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
                    }
                    
                })
            }
        }
        
        return cell
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        enteredFromMenuIndex = 1
        
        //PageIndex = 0
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
        
        self.present(slideViewController, animated: true, completion: nil)
    }
    
    func loadData()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let myQuizListParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String,"quiz_id" : QuizId]
        
        print(myQuizListParameters)
        
        Alamofire.request(myQuizResultAPI, method: .post, parameters: myQuizListParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                self.MyQuizLeaderBoard = JSON(response.result.value!)
                
                if(self.MyQuizLeaderBoard["status"] == "success" && self.MyQuizLeaderBoard["status_code"].intValue == 1)
                {
                    
                   self.MyQuizLeaderboardTableView.reloadData()
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
