//
//  MyQuizViewController.swift
//  QuizApp
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MyQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var MyQuizTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        MyQuizTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = MyQuizTableView.dequeueReusableCell(withIdentifier: "myQuizTableViewCell", for: indexPath) as! MyQuizTableViewCell
        
        return cell
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
