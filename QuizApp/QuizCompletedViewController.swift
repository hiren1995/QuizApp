//
//  QuizCompletedViewController.swift
//  QuizApp
//
//  Created by Apple on 12/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class QuizCompletedViewController: UIViewController {

    @IBOutlet var lblScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        lblScore.text = "\(scoredPoints)/\(totalPoints)"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            
            scoredPoints = 0
            totalPoints = 5
            
            enteredFromMenuIndex = 0
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
            
            self.present(slideViewController, animated: true, completion: nil)
            
        }
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
