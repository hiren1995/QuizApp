//
//  LeaderBoardViewController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import PageMenu

class LeaderBoardViewController: UIViewController {

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTabBarStrip()
        

        // Do any additional setup after loading the view.
    }

    func loadTabBarStrip()
    {
        var controllerArray : [UIViewController] = []
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let allQuizViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: "allQuizViewController") as! AllQuizViewController
        allQuizViewController.title = "ALL QUIZ"
        controllerArray.append(allQuizViewController)
        
        let globalQuizViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: "globalQuizViewController") as! GlobalQuizViewController
        globalQuizViewController.title = "GLOBAL QUIZ"
        controllerArray.append(globalQuizViewController)
        
       
        var parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        //pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        pageMenu =  CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height-100), pageMenuOptions: parameters)
        
        
        
        self.view.addSubview(pageMenu!.view)
        
        
        
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        
        
        let slidemenu = self.slideMenuController()
        
        slidemenu?.openLeft()
        
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
