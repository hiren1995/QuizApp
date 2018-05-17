//
//  ParticularQuizViewController.swift
//  QuizApp
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Kingfisher

class ParticularQuizViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var ParticularQuizTableView: UITableView!
    
    var username = ["User 1","User2","User 3","User 1","User2","User 3","User 1","User2","User 3"]
    var completedTime = ["10","20","30","10","20","30","10","20","30"]
    
    var userlevel = ["1","5","10","1","5","10","1","5","10"]
    
    var QuizId = Int()
    
    var winnerList = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ParticularQuizTableView.delegate = self
        ParticularQuizTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return username.count
        return winnerList["quiz_result"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ParticularQuizTableView.dequeueReusableCell(withIdentifier: "particularQuizTableViewCell", for: indexPath) as! ParticularQuizTableViewCell
        
        cell.selectionStyle = .none

        /*
        cell.lblUserName.text = username[indexPath.row]
        cell.lblCompletionTime.text = completedTime[indexPath.row] + " seconds"
        cell.lblLevel.text = userlevel[indexPath.row]
        */
        
        cell.lblUserName.text = winnerList["quiz_result"][indexPath.row]["user_name"].stringValue
        cell.lblCompletionTime.text = winnerList["quiz_result"][indexPath.row]["time_taken_to_finish"].stringValue + " seconds"
        cell.lblLevel.text = String(indexPath.row + 1)
        
        KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: winnerList["quiz_result"][indexPath.row]["user_profile_photo"].stringValue)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
            
            if(error == nil)
            {
                cell.imgUser.image = image
                
            }
            else
            {
                //self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
            }
            
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        enteredFromMenuIndex = 1
        
        //PageIndex = 1
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
        
        self.present(slideViewController, animated: true, completion: nil)
    }
    
    func loadData()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let QuizWinnerListParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String,"quiz_id" : QuizId]
        
        print(QuizWinnerListParameters)
        
        Alamofire.request(myQuizResultAPI, method: .post, parameters: QuizWinnerListParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                self.winnerList = JSON(response.result.value!)
                
                if(self.winnerList["status"] == "success" && self.winnerList["status_code"].intValue == 1)
                {
                    
                    self.ParticularQuizTableView.reloadData()
                }
                
                else if(self.winnerList["status"] == "failure" && self.winnerList["status_code"].intValue == 0 && self.winnerList["message"] == "No winners yet.")
                {
                    self.showAlert(title: "Alert", message: "No winners yet")
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
