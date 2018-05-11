//
//  GlobalQuizViewController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class GlobalQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var GlobalQuizTableView: UITableView!
    
    var username = ["User 1","User2","User 3","User 1","User2","User 3","User 1","User2","User 3"]
    var completedTime = ["10","20","30","10","20","30","10","20","30"]
    
    var userlevel = ["1","5","10","1","5","10","1","5","10"]
    
    var quizname = ["Quiz 1","Quiz 2","Quiz 3","Quiz 1","Quiz 2","Quiz 3","Quiz 1","Quiz 2","Quiz 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GlobalQuizTableView.delegate = self
        GlobalQuizTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return username.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = GlobalQuizTableView.dequeueReusableCell(withIdentifier: "globalQuizTableViewCell", for: indexPath) as! GlobalQuizTableViewCell
        
        cell.lblUserName.text = username[indexPath.row]
        cell.lblCompletionTime.text = completedTime[indexPath.row] + " seconds"
        
        cell.lblQuizName.text = quizname[indexPath.row]
        cell.lblLevel.text = userlevel[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
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
