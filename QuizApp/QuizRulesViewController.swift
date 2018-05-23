//
//  QuizRulesViewController.swift
//  QuizApp
//
//  Created by Apple on 23/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class QuizRulesViewController: UIViewController {
    @IBOutlet var txtRules: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtRules.text = "1.This is simple quiz app allows user to play and win quiz every 15 mins. \n\n\n 2.Every 15 mins will have a new quiz. \n\n\n 3.Winners are are chosen on the fastest-finger-first basis. \n\n\n 4.Looser will have cooling period of 15 mins. \n\n\n 5.Only 5 winners will be chosen as final winner. \n\n\n 6.Winners would be awarded by the gift on the event day. \n\n\n 7.We do not promote any illegal activity through this quiz. \n\n\n 8.In any way Apple is not sponsoring this application. \n\n\n 9.Avoid using this app if you are below 17 years of age."
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBack(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
        
        self.present(slideViewController, animated: true, completion: nil)
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
