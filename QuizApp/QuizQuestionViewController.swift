//
//  QuizQuestionViewController.swift
//  QuizApp
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

var totalPoints = 5
var scoredPoints = 0


class QuizQuestionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    var Questions = ["Which place is Capital of Gujarat ?","Which Place is Capital of India ?","Which country is hot favourite for abroad studies ?","Which city is pink city of India ?","Who is father of Computer ?"]
    
    var options = [
        
        0 : ["Ahmedabad","Vadodara","Gandhinagar","Surat"],
        1 : ["Mumbai","Goa","Delhi","Punjab"],
        2 : ["United States","Canada","Australia","Poland"],
        3 : ["Udaipur","Jaipur","Jodhpur","Jaisalmer"],
        4 : ["Charles Babbage","Albert Einstein","Issac Newton","James Thomson"]
    ]
    
    var answerset = ["C","C","B","B","A"]
    
    var selectedAnswer = String()
    var questionIndex = 0
    
    
    var Quiz_id = Int()
    var Result_id = Int()
    var QuestionList = JSON()
    @IBOutlet var lblQuizName: UILabel!
    
    
    //Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
    
    @IBOutlet var QuizQuestionTableView: UITableView!
    
    var imgOptionA = UIImageView()
    var imgOptionB = UIImageView()
    var imgOptionC = UIImageView()
    var imgOptionD = UIImageView()
    
    var btnOptionA = UIButton()
    var btnOptionB = UIButton()
    var btnOptionC = UIButton()
    var btnOptionD = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QuizQuestionTableView.delegate = self
        QuizQuestionTableView.dataSource = self
        
        loadData()
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("QuizQuestionTableViewCell", owner: self, options: nil)?.first as! QuizQuestionTableViewCell
        
        cell.lblQuestionNo.text = "Question " + "\(questionIndex+1)"
        
        //cell.lblQuestion.text = Questions[questionIndex]
        
        
        cell.lblQuestion.text = self.QuestionList["quiz_list"][questionIndex]["question_title"].stringValue
        
        cell.btnOptionA.setTitle(self.QuestionList["quiz_list"][questionIndex]["question_option1"].stringValue, for: .normal)
        cell.btnOptionB.setTitle(self.QuestionList["quiz_list"][questionIndex]["question_option2"].stringValue, for: .normal)
        cell.btnOptionC.setTitle(self.QuestionList["quiz_list"][questionIndex]["question_option3"].stringValue, for: .normal)
        cell.btnOptionD.setTitle(self.QuestionList["quiz_list"][questionIndex]["question_option4"].stringValue, for: .normal)
        
        
        cell.isHighlighted = false
        
        imgOptionA = cell.imgOptionA
        imgOptionB = cell.imgOptionB
        imgOptionC = cell.imgOptionC
        imgOptionD = cell.imgOptionD
        
        btnOptionA = cell.btnOptionA
        btnOptionB = cell.btnOptionB
        btnOptionC = cell.btnOptionC
        btnOptionD = cell.btnOptionD
       
        //cell.btnOptionA.setTitle(options[questionIndex]?[0], for: .normal)
        //cell.btnOptionB.setTitle(options[questionIndex]?[1], for: .normal)
        //cell.btnOptionC.setTitle(options[questionIndex]?[2], for: .normal)
        //cell.btnOptionD.setTitle(options[questionIndex]?[3], for: .normal)
        
        
        cell.btnOptionA.addTarget(self, action: #selector(OptionASelected), for: .touchUpInside)
        cell.btnOptionB.addTarget(self, action: #selector(OptionBSelected), for: .touchUpInside)
        cell.btnOptionC.addTarget(self, action: #selector(OptionCSelected), for: .touchUpInside)
        cell.btnOptionD.addTarget(self, action: #selector(OptionDSelected), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    @objc func OptionASelected()
    {
        if(imgOptionB.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionB.backgroundColor = UIColor.white
            btnOptionB.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else if(imgOptionC.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionC.backgroundColor = UIColor.white
            btnOptionC.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else if(imgOptionD.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionD.backgroundColor = UIColor.white
            btnOptionD.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else
        {
            imgOptionA.backgroundColor = UIColor.white
            btnOptionA.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        
        imgOptionA.backgroundColor = UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0)
        btnOptionA.setTitleColor(UIColor.white, for: .normal)
        
        selectedAnswer = "a"
    }
    
    @objc func OptionBSelected()
    {
        if(imgOptionA.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionA.backgroundColor = UIColor.white
            btnOptionA.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else if(imgOptionC.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionC.backgroundColor = UIColor.white
            btnOptionC.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else if(imgOptionD.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionD.backgroundColor = UIColor.white
            btnOptionD.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else
        {
            imgOptionB.backgroundColor = UIColor.white
            btnOptionB.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        
        imgOptionB.backgroundColor = UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0)
        btnOptionB.setTitleColor(UIColor.white, for: .normal)
        
        selectedAnswer = "b"
    }
    
    @objc func OptionCSelected()
    {
        if(imgOptionA.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionA.backgroundColor = UIColor.white
            btnOptionA.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else if(imgOptionB.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionB.backgroundColor = UIColor.white
            btnOptionB.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else if(imgOptionD.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionD.backgroundColor = UIColor.white
            btnOptionD.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else
        {
            imgOptionC.backgroundColor = UIColor.white
            btnOptionC.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        
        imgOptionC.backgroundColor = UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0)
        btnOptionC.setTitleColor(UIColor.white, for: .normal)
        
        selectedAnswer = "c"
    }
    
    @objc func OptionDSelected()
    {
        if(imgOptionA.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionA.backgroundColor = UIColor.white
            btnOptionA.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else if(imgOptionB.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionB.backgroundColor = UIColor.white
            btnOptionB.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else if(imgOptionC.backgroundColor == UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0))
        {
            imgOptionC.backgroundColor = UIColor.white
            btnOptionC.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        else
        {
            imgOptionD.backgroundColor = UIColor.white
            btnOptionD.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), for: .normal)
        }
        
        imgOptionD.backgroundColor = UIColor(red: 41/255, green: 218/255, blue: 37/255, alpha: 1.0)
        btnOptionD.setTitleColor(UIColor.white, for: .normal)
        
        selectedAnswer = "d"
    }
    
    @IBAction func btnNextQuestion(_ sender: UIButton) {
        
        //if(selectedAnswer == answerset[questionIndex])
        
        if(selectedAnswer == self.QuestionList["quiz_list"][questionIndex]["answer"].stringValue)
        {
            scoredPoints += 1
        }
        
        //if(questionIndex < Questions.count-1)
        
        if(questionIndex < self.QuestionList["quiz_list"].count-1)
        {
            
            print(questionIndex)
            questionIndex += 1
            QuizQuestionTableView.reloadData()
            
        }
        else
        {
            let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            var isWinner = 1
            
            if(scoredPoints == self.QuestionList["quiz_list"].count)
            {
                isWinner = 2
            }
            
            let EndQuizParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String,"quiz_id" : Quiz_id , "quiz_user_end_time" : "2018-05-14 18:58:12","quiz_user_end_min": "120" ,"right_ans_count":scoredPoints,"result_id":Result_id,"user_all_ans":"" ,"is_winner":isWinner]
            
            print(EndQuizParameters)
            
            Alamofire.request(quizEndAPI, method: .post, parameters: EndQuizParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if(response.result.value != nil)
                {
                    Spinner.hide(animated: true)
                    
                    print(JSON(response.result.value))
                    
                    let tempDict = JSON(response.result.value!)
                    
                    if(tempDict["status"] == "success" && tempDict["status_code"].intValue == 1)
                    {
                        
                        //self.QuizListCollectionView.reloadData()
                        
                        let alert = UIAlertController(title: "Congratulatios", message: tempDict["message"].stringValue, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let quizCompletedViewController = storyboard.instantiateViewController(withIdentifier: "quizCompletedViewController") as! QuizCompletedViewController
                            
                            self.present(quizCompletedViewController, animated: true, completion: nil)
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                       
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
            
            //let quizCompletedViewController = storyboard.instantiateViewController(withIdentifier: "quizCompletedViewController") as! QuizCompletedViewController
            
            //self.present(quizCompletedViewController, animated: true, completion: nil)
        }
        
    }
    
    func loadData()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let getQuestionsParameters:Parameters = ["user_id":userdefault.value(forKey: userId) as! String,"user_token": userdefault.value(forKey: userToken) as! String,"quiz_id" : Quiz_id]
        
        print(getQuestionsParameters)
        
        Alamofire.request(questionListAPI, method: .post, parameters: getQuestionsParameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                Spinner.hide(animated: true)
                
                print(JSON(response.result.value))
                
                self.QuestionList = JSON(response.result.value!)
                
                if(self.QuestionList ["status"] == "success" && self.QuestionList ["status_code"].intValue == 1)
                {
                    
                    self.QuizQuestionTableView.reloadData()
                    totalPoints = self.QuestionList["quiz_list"].count
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
