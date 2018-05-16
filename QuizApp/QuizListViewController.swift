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

class QuizListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var QuizListCollectionView: UICollectionView!
    
    var quizlist = ["Maths Quiz","Chemistry Quiz","Geography Quiz","Maths Quiz","Chemistry Quiz","Geography Quiz","Maths Quiz","Chemistry Quiz","Geography Quiz"]
    
    var imgquiz = ["maths","chemistry","geography","maths","chemistry","geography","maths","chemistry","geography"]
    
    
    var QuizList = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        QuizListCollectionView.delegate = self
        QuizListCollectionView.dataSource = self
        
        loadQuizList()
        
        // Do any additional setup after loading the view.
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
