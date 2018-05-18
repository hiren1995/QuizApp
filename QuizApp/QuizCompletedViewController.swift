//
//  QuizCompletedViewController.swift
//  QuizApp
//
//  Created by Apple on 12/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import Kingfisher

class QuizCompletedViewController: UIViewController {

    @IBOutlet var lblScore: UILabel!
    @IBOutlet var imgUserPic: UIImageView!
    @IBOutlet var lblQuizName: UILabel!
    @IBOutlet var lblQuizCompletedTime: UILabel!
    
    var QuizTime = Int()
    var QuizName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            
            self.backToDashboard()
            
        }
    }
    @IBAction func btnBack(_ sender: UIButton) {
        
        backToDashboard()
    }
    
    func backToDashboard()
    {
        scoredPoints = 0
        totalPoints = 5
        
        enteredFromMenuIndex = 0
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
        
        self.present(slideViewController, animated: true, completion: nil)
    }
    
    func loadData()
    {
        lblScore.text = "\(scoredPoints)/\(totalPoints)"
        
        lblQuizName.text = QuizName
        lblQuizCompletedTime.text = "Quiz completed in \(QuizTime) Seconds"
        
        let userdata = JSON(userdefault.value(forKey: userData))
        
        let imgurl = userdata["login_user"][0]["user_profile_photo"].stringValue
        
        KingfisherManager.shared.downloader.downloadImage(with: NSURL(string: imgurl)! as URL, retrieveImageTask: RetrieveImageTask.empty, options: [], progressBlock: nil, completionHandler: { (image,error, imageURL, imageData) in
            
            
            if(error == nil)
            {
                self.imgUserPic.image = image
                
            }
            else
            {
                self.showAlert(title: "Alert", message: "Something Went Wrong while downloading Profile Image")
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
