//
//  QuizListViewController.swift
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
import Kingfisher
import Foundation

var QuizTimeOut = Int()
var WinnerTimeOut = Int()
var LooserTimeOut = Int()

class QuizListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var QuizListCollectionView: UICollectionView!
    
    var quizlist = ["Maths Quiz","Chemistry Quiz","Geography Quiz","Maths Quiz","Chemistry Quiz","Geography Quiz","Maths Quiz","Chemistry Quiz","Geography Quiz"]
    
    var imgquiz = ["maths","chemistry","geography","maths","chemistry","geography","maths","chemistry","geography"]
    
    
    var QuizList = JSON()
    
    
    var currentTime = Date()
    
    var countdownTimer: Timer!
    
    var totalTime = Int()
    
    var Joinbtn = UIButton()
    
    private var AppForegroundNotification: NSObjectProtocol?
    private var AppBackgroundNotification: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        QuizListCollectionView.delegate = self
        QuizListCollectionView.dataSource = self
        
        
        totalTime = 0
        
        AppForegroundNotification = NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: .main) {
            [unowned self] notification in
            
            self.ResumeApp()
        }
        
        AppBackgroundNotification = NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: .main) {
            [unowned self] notification in
            
            self.PauseApp()
        }
        
        
        //loadQuizList()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        
        if let appforegroundnotification = AppForegroundNotification {
            NotificationCenter.default.removeObserver(appforegroundnotification)
        }
        if let appbackgroundnotification = AppBackgroundNotification{
            
            NotificationCenter.default.removeObserver(appbackgroundnotification)
        }
        
        //stopAutoRefreshTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadQuizList()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        //return quizlist.count
        
        return QuizList["quiz_list"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = QuizListCollectionView.dequeueReusableCell(withReuseIdentifier: "quizListCollectionViewCell", for: indexPath) as! QuizListCollectionViewCell
        
        
        cell.ViewQuiz.addBorderShadow(shadowOpacity: 0.3, shadowRadius: 2.0, shadowColor: UIColor.darkGray)
        
        /*
        cell.imgQuiz.image = UIImage(named: imgquiz[indexPath.row])
        cell.lblQuiz.text = quizlist[indexPath.row]
        
        cell.btnJoinQuiz.addTarget(self, action: #selector(JoinQuiz), for: .touchUpInside)
        */
        
       
        //cell.imgQuiz.image = UIImage(named: imgquiz[indexPath.row])
        cell.lblQuiz.text = QuizList["quiz_list"][indexPath.row]["quiz_name"].stringValue
        
        cell.btnJoinQuiz.tag = indexPath.row
        cell.btnJoinQuiz.addTarget(self, action: #selector(JoinQuiz(sender:)), for: .touchUpInside)
        
        
        
        //Joinbtn = cell.btnJoinQuiz
        
        if(QuizList["quiz_list"][indexPath.row]["is_quiz_completed"].exists())
        {
            if(QuizList["quiz_list"][indexPath.row]["is_quiz_completed"].intValue == 2)
            {
                cell.btnJoinQuiz.setTitle("Attempted", for: .normal)
                cell.btnJoinQuiz.setTitleColor(UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0), for: .normal)
                cell.btnJoinQuiz.isUserInteractionEnabled = false
            }
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let startTime = dateFormatter.date(from: QuizList["quiz_list"][indexPath.row]["quiz_start_time"].stringValue)
            let startTimeMillis = startTime?.timeIntervalSince1970
            
            let EndTime = dateFormatter.date(from: QuizList["quiz_list"][indexPath.row]["quiz_end_time"].stringValue)
            let EndTimeMillis = EndTime?.timeIntervalSince1970
            
            let currentTimeMillis = currentTime.timeIntervalSince1970
            
            if(Double(startTimeMillis!) > Double (currentTimeMillis))
            {
                cell.btnJoinQuiz.isUserInteractionEnabled = false
                
                cell.btnJoinQuiz.setTitleColor(UIColor.gray, for: .normal)
                
                Joinbtn = cell.btnJoinQuiz
                
                totalTime = Int(startTimeMillis! - currentTimeMillis)
                
                startTimer()
            }
            else if(Double(startTimeMillis!) < Double(currentTimeMillis) && Double(EndTimeMillis!) > Double(currentTimeMillis))
            {
                cell.btnJoinQuiz.setTitle("Join", for: .normal)
                cell.btnJoinQuiz.setTitleColor(UIColor(red: 80/255, green: 124/255, blue: 255/255, alpha: 1.0), for: .normal)
                cell.btnJoinQuiz.isUserInteractionEnabled = true
            }
            else
            {
                cell.btnJoinQuiz.setTitle("Enlapsed", for: .normal)
                cell.btnJoinQuiz.isUserInteractionEnabled = false
            }
        }
        
        
        KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: QuizList["quiz_list"][indexPath.row]["level_logo"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
            
            
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 185, height: 185)
    }
    
    @objc func JoinQuiz(sender : UIButton)
    {
        print(sender.tag)
        
        
        
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let JoinQuiztParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String,"quiz_id" : QuizList["quiz_list"][sender.tag]["quiz_id"].stringValue]
        
        print(JoinQuiztParameters)
        
        Alamofire.request(quizJoinAPI, method: .post, parameters: JoinQuiztParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                let tempDict = JSON(response.result.value!)
                
                if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 1)
                {
                    
                    //self.QuizListCollectionView.reloadData()
                    
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let quizQuestionViewController = storyboard.instantiateViewController(withIdentifier: "quizQuestionViewController") as! QuizQuestionViewController
                    
                    quizQuestionViewController.QuizTimeOut = self.QuizList["quiz_time_out"].intValue * 60
                    quizQuestionViewController.Quiz_id = self.QuizList["quiz_list"][sender.tag]["quiz_id"].intValue
                    quizQuestionViewController.Result_id = tempDict["result_id"].intValue
                    
                    self.present(quizQuestionViewController, animated: true, completion: nil)
                    
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
        
        
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //let quizQuestionViewController = storyboard.instantiateViewController(withIdentifier: "quizQuestionViewController") as! QuizQuestionViewController
        
        //self.present(quizQuestionViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        
        
        let slidemenu = self.slideMenuController()
        
        slidemenu?.openLeft()
        
    }
    
    func loadQuizList()
    {
        currentTime = Date()
        print(currentTime.timeIntervalSince1970)
        
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let QuizListParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String]
        
        print(QuizListParameters)
        
        Alamofire.request(quizListAPI, method: .post, parameters: QuizListParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                self.QuizList = JSON(response.result.value!)
                
                if(self.QuizList["status"] == "success" && self.QuizList["status_code"].intValue == 1)
                {
                   
                    self.QuizListCollectionView.reloadData()
                    //self.startTimer()
                    
                }
                    
                else if(self.QuizList["status"] == "failure" && self.QuizList["status_code"].intValue == 0 && self.QuizList["message"].stringValue == "No Quiz Found.")
                {
                    self.showAlert(title: "No Quiz Found", message: "No Quiz is Currently available Please try again after some time.")
                }
                else
                {
                    self.showAlert(title: "Alert", message: "Invalid User")
                }
                
            }
            else
            {
                Spinner.hide(animated: true)
                self.showAlert(title: "Alert", message: "Please Check Your Internet Connection")
            }
        })
        
        
    }
    
    
    
    //Count Down Timer code
    
    func startTimer() {
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        //tempTimer.text = "\(timeFormatted(totalTime))"
        
        Joinbtn.setTitle(timeFormatted(totalTime), for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
            
        } else {
            
            loadQuizList()
            endTimer()
        }
    }
    
    func endTimer() {
        
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours,minutes, seconds)
        
        
        /*
         let seconds: Int = ((totalSeconds%(1000*60*60))%(1000*60))/1000
         let minutes: Int = (totalSeconds % (1000*60*60))/(1000*60)
         let hours: Int = totalSeconds / (1000*60*60)
         return String(format: "%02d:%02d:%02d", hours,minutes, seconds)
         */
        
        //return String(format: "%02d",totalSeconds)
    }

    @objc func ResumeApp()
    {
        print("Application running again from background")
        
        currentTime = Date()
        print(currentTime.timeIntervalSince1970)
        
        //self.loadFastLog(From_Date : self.from_date , To_Date : self.to_date)
        
        loadQuizList()
        
    }
    
    @objc func PauseApp()
    {
        print("Application is kept in background")
        
        endTimer()
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
