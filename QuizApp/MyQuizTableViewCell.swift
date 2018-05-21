//
//  MyQuizTableViewCell.swift
//  QuizApp
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MarqueeLabel

class MyQuizTableViewCell: UITableViewCell {

    
    @IBOutlet var imgQuiz: UIImageView!
    //@IBOutlet var lblQuizName: UILabel!
    @IBOutlet var lblQuizStatus: UILabel!
    @IBOutlet var lblQuizName: MarqueeLabel!
    
    @IBOutlet var lblQuizTime: UILabel!
    
    @IBOutlet var lblQuizStartTime: UILabel!
    @IBOutlet var lblQuizEndTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
