//
//  DashBoardTabBarController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

var enteredFromMenuIndex = 0

class DashBoardTabBarController: UITabBarController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(enteredFromMenuIndex)
        
        if(enteredFromMenuIndex == 0)
        {
            self.selectedIndex = 0
        }
        else if(enteredFromMenuIndex == 1)
        {
            self.selectedIndex = 1
        }
        else if(enteredFromMenuIndex == 2)
        {
            self.selectedIndex = 2
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
