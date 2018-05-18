//
//  AllQuizViewController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import Kingfisher

class AllQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var AllQuizTableView: UITableView!
    
    var AllQuizList = JSON()
    
    var quizlist = ["Quiz 1","Quiz 2","Quiz 3" ,"Quiz 4","Quiz 5" , "Quiz 6","Quiz 7" , "Quiz 8","Quiz 9" , "Quiz 10"]
    var quizimg = ["quiz1","quiz2","quiz1","quiz2","quiz1","quiz2","quiz1","quiz2","quiz1","quiz2"]
    var status = ["(Finished)","(Attempted)","(Finished)","(Attempted)","(Finished)","(Attempted)","(Finished)","(Attempted)","(Finished)","(Attempted)"]
    var time = ["01:00:00 - 01:15:00" , "05:00:00 - 05:30:00","01:00:00 - 01:15:00" , "05:00:00 - 05:30:00","01:00:00 - 01:15:00" , "05:00:00 - 05:30:00","01:00:00 - 01:15:00" , "05:00:00 - 05:30:00","01:00:00 - 01:15:00" , "05:00:00 - 05:30:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AllQuizTableView.delegate = self
        AllQuizTableView.dataSource = self
        //AllQuizTableView.allowsSelection = false
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //AllQuizTableView.reloadData()
        
        loadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return quizlist.count
        
        return AllQuizList["quiz_list"].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = AllQuizTableView.dequeueReusableCell(withIdentifier: "allQuizTableViewCell", for: indexPath) as! AllQuizTableViewCell
        
        cell.selectionStyle = .none

        /*
        cell.imgQuiz.image = UIImage(named: quizimg[indexPath.row])
        cell.lblQuizName.text = quizlist[indexPath.row]
        cell.lblQuizStatus.text = status[indexPath.row]
        //cell.lblQuizTime.text = time[indexPath.row]
        
        
        */
        
        if(AllQuizList != JSON.null && AllQuizList["quiz_list"].count != 0)
        {
            cell.lblQuizName.text = AllQuizList["quiz_list"][indexPath.row]["quiz_name"].stringValue
            
            let starttime = getTimeFromDate(datestr: AllQuizList["quiz_list"][indexPath.row]["quiz_start_time"].stringValue)
            let endtime = getTimeFromDate(datestr: AllQuizList["quiz_list"][indexPath.row]["quiz_end_time"].stringValue)
            print(starttime)
            
            cell.lblQuizStartTime.text = starttime
            cell.lblQuizEndTime.text = endtime

            if(AllQuizList["quiz_list"][indexPath.row]["is_quiz_completed"].exists())
            {
                if(AllQuizList["quiz_list"][indexPath.row]["is_quiz_completed"].intValue == 2)
                {
                    cell.lblQuizStatus.text = "(Attempted)"
                    cell.lblQuizStatus.textColor = UIColor.green
                }
                else
                {
                    cell.lblQuizStatus.text = "(Elapsed)"
                    cell.lblQuizStatus.textColor = UIColor.red
                }
                
            }
            else
            {
                cell.lblQuizStatus.text = "(Elapsed)"
                cell.lblQuizStatus.textColor = UIColor.red
            }
           
            
            //cell.lblQuizTime.text = time[indexPath.row]
            
            KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: AllQuizList["quiz_list"][indexPath.row]["level_logo"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
                
                if(error == nil)
                {
                    cell.imgQuiz.image = image
                    
                }
                else
                {
                    //self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
                }
                
            })
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let particularQuizViewController = storyboard.instantiateViewController(withIdentifier: "particularQuizViewController") as! ParticularQuizViewController
        particularQuizViewController.QuizId = AllQuizList["quiz_list"][indexPath.row]["quiz_id"].intValue
        particularQuizViewController.QuizName = AllQuizList["quiz_list"][indexPath.row]["quiz_name"].stringValue
        self.present(particularQuizViewController, animated: true, completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 146
        
        
    }
   
    func loadData()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let GlobalLeaderboardParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String]
        
        print(GlobalLeaderboardParameters)
        
        Alamofire.request(leaderBoardQuizListAPI, method: .post, parameters: GlobalLeaderboardParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print("This is all quiz list for leaderboard")
                
                print(JSON(response.result.value))
                
                
                self.AllQuizList = JSON(response.result.value!)
                
                if(self.AllQuizList["status"] == "success" && self.AllQuizList["status_code"].intValue == 1)
                {
                    
                    self.AllQuizTableView.reloadData()
                }
                    
                else
                {
                    self.showAlert(title: "Alert", message: "No Quiz available currently or Something went wrong while getting Quiz")
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
