//
//  QuizListViewController.swift
//  QuizApp
//
//  Created by Apple on 10/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class QuizListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var QuizListCollectionView: UICollectionView!
    
    var quizlist = ["Maths Quiz","Chemistry Quiz","Geography Quiz","Maths Quiz","Chemistry Quiz","Geography Quiz","Maths Quiz","Chemistry Quiz","Geography Quiz"]
    
    var imgquiz = ["maths","chemistry","geography","maths","chemistry","geography","maths","chemistry","geography"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        QuizListCollectionView.delegate = self
        QuizListCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return quizlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = QuizListCollectionView.dequeueReusableCell(withReuseIdentifier: "quizListCollectionViewCell", for: indexPath) as! QuizListCollectionViewCell
        
        cell.ViewQuiz.addBorderShadow(shadowOpacity: 0.3, shadowRadius: 2.0, shadowColor: UIColor.darkGray)
        
        cell.imgQuiz.image = UIImage(named: imgquiz[indexPath.row])
        cell.lblQuiz.text = quizlist[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 185, height: 185)
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
