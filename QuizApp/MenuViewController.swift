//
//  MenuViewController.swift
//  QuizApp
//
//  Created by Apple on 09/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet var MenuTableView: UITableView!
    
    var list = ["Quiz List","LeaderBoard","About Us","Logout"]
    var imglist = ["ic_quiz_list","ic_leader","ic_settings","logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MenuTableView.delegate = self
        MenuTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = MenuTableView.dequeueReusableCell(withIdentifier: "menuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        cell.imgList.image = UIImage(named: imglist[indexPath.row])
        cell.lblList.text = list[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(indexPath.row != 3)
        {
            print(indexPath.row)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            enteredFromMenuIndex = indexPath.row
            
            let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
            
            self.present(slideViewController, animated: false, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "User Already Registered", message: "Please Login as you are already registered from this mobile number", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                
                userdefault.removeObject(forKey: userId)
                userdefault.removeObject(forKey: userToken)
                userdefault.removeObject(forKey: userData)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signInViewController = storyboard.instantiateViewController(withIdentifier: "signInViewController") as! SignInViewController
                
                self.present(signInViewController, animated: true, completion: nil)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 70
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
