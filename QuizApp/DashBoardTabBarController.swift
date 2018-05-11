//
//  DashBoardTabBarController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DashBoardTabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(backFromParticularQuiz == 1)
        {
            self.selectedIndex = 1
        }
        
        // Do any additional setup after loading the view.
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
