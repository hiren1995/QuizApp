//
//  GlobalQuizViewController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import Kingfisher

class GlobalQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var GlobalQuizTableView: UITableView!
    
    var username = ["User 1","User2","User 3","User 1","User2","User 3","User 1","User2","User 3"]
    var completedTime = ["10","20","30","10","20","30","10","20","30"]
    
    var userlevel = ["1","5","10","1","5","10","1","5","10"]
    
    var quizname = ["Quiz 1","Quiz 2","Quiz 3","Quiz 1","Quiz 2","Quiz 3","Quiz 1","Quiz 2","Quiz 3"]
    
    var GlobalLeaders = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GlobalQuizTableView.delegate = self
        GlobalQuizTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        //GlobalQuizTableView.reloadData()
        
        loadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       //return username.count
        
        return GlobalLeaders["quiz_result"].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = GlobalQuizTableView.dequeueReusableCell(withIdentifier: "globalQuizTableViewCell", for: indexPath) as! GlobalQuizTableViewCell
        
        cell.selectionStyle = .none

        /*
        cell.lblUserName.text = username[indexPath.row]
        cell.lblCompletionTime.text = completedTime[indexPath.row] + " seconds"
        
        cell.lblQuizName.text = quizname[indexPath.row]
        cell.lblLevel.text = userlevel[indexPath.row]
        
         */
        
        cell.lblUserName.text = GlobalLeaders["quiz_result"][indexPath.row]["user_name"].stringValue
        cell.lblCompletionTime.text = GlobalLeaders["quiz_result"][indexPath.row]["time_taken_to_finish"].stringValue + " seconds"
        
        cell.lblQuizName.text = GlobalLeaders["quiz_result"][indexPath.row]["quiz_name"].stringValue
        cell.lblLevel.text = String(indexPath.row + 1)
        
        if(GlobalLeaders["quiz_result"][indexPath.row]["user_profile_photo"].stringValue != "")
        {
            KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: GlobalLeaders["quiz_result"][indexPath.row]["user_profile_photo"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                
                if(error == nil)
                {
                    cell.imgUser.image = image
                    
                }
                else
                {
                    //self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
                }
                
            })
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func loadData()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let GlobalLeaderboardParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String]
        
        print(GlobalLeaderboardParameters)
        
        Alamofire.request(globalLeaderBoardAPI, method: .post, parameters: GlobalLeaderboardParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                self.GlobalLeaders = JSON(response.result.value!)
                
                if(self.GlobalLeaders["status"] == "success" && self.GlobalLeaders["status_code"].intValue == 1)
                {
                    
                    self.GlobalQuizTableView.reloadData()
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
