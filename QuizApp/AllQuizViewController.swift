//
//  AllQuizViewController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AllQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var AllQuizTableView: UITableView!
    
    
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quizlist.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = AllQuizTableView.dequeueReusableCell(withIdentifier: "allQuizTableViewCell", for: indexPath) as! AllQuizTableViewCell
        
        cell.imgQuiz.image = UIImage(named: quizimg[indexPath.row])
        cell.lblQuizName.text = quizlist[indexPath.row]
        cell.lblQuizStatus.text = status[indexPath.row]
        //cell.lblQuizTime.text = time[indexPath.row]
        
        //cell.btnViewLeaderboard.addTarget(self, action: #selector(viewLeaderBoard), for: .touchUpInside)
        
        return cell
    }
    
    /*
    @objc func viewLeaderBoard()
    {
        
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let particularQuizViewController = storyboard.instantiateViewController(withIdentifier: "particularQuizViewController") as! ParticularQuizViewController
        self.present(particularQuizViewController, animated: true, completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 146
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
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
