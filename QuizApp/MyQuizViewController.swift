//
//  MyQuizViewController.swift
//  QuizApp
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import Kingfisher

class MyQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var MyQuizTableView: UITableView!
    
    var myQuizList = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyQuizTableView.delegate = self
        MyQuizTableView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MyQuizTableView.reloadData()
        
        loadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return 10
        
        return myQuizList["quiz_list"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = MyQuizTableView.dequeueReusableCell(withIdentifier: "myQuizTableViewCell", for: indexPath) as! MyQuizTableViewCell
        
        cell.selectionStyle = .none
        
        cell.lblQuizName.text = myQuizList["quiz_list"][indexPath.row]["quiz_name"].stringValue
        
        //cell.lblQuizStatus.text = myQuizList["quiz_list"][indexPath.row]["quiz_name"].stringValue
        
        let starttime = getTimeFromDate(datestr: myQuizList["quiz_list"][indexPath.row]["quiz_start_time"].stringValue)
        let endtime = getTimeFromDate(datestr: myQuizList["quiz_list"][indexPath.row]["quiz_user_end_time"].stringValue)
        print(starttime)
        
        cell.lblQuizStartTime.text = starttime
        
        cell.lblQuizEndTime.text = endtime
        
        KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: myQuizList["quiz_list"][indexPath.row]["level_logo"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
            
            
            if(error == nil)
            {
                cell.imgQuiz.image = image
                
            }
            else
            {
                self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
            }
            
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let myQuizLeaderboardViewController = storyboard.instantiateViewController(withIdentifier: "myQuizLeaderboardViewController") as! MyQuizLeaderboardViewController
        
        myQuizLeaderboardViewController.QuizId = myQuizList["quiz_list"][indexPath.row]["quiz_id"].intValue
        
        self.present(myQuizLeaderboardViewController, animated: true, completion: nil)
        
    }

    func loadData()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let myQuizListParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String]
        
        print(myQuizListParameters)
        
        Alamofire.request(myQuizListAPI, method: .post, parameters: myQuizListParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                self.myQuizList = JSON(response.result.value!)
                
                if(self.myQuizList["status"] == "success" && self.myQuizList["status_code"].intValue == 1)
                {
                    
                   self.MyQuizTableView.reloadData()
                    
                }
                else if(self.myQuizList["status"] == "failure" && self.myQuizList["status_code"].intValue == 0 && self.myQuizList["message"].stringValue == "No Quiz Found.")
                {
                    self.showAlert(title: "Alert", message: "No Quiz Found.")
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
