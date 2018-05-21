//
//  AllQuizTableViewCell.swift
//  QuizApp
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MarqueeLabel

class AllQuizTableViewCell: UITableViewCell {

    @IBOutlet var imgQuiz: UIImageView!
    //@IBOutlet var lblQuizName: UILabel!
    @IBOutlet var lblQuizStatus: UILabel!
    
    @IBOutlet var lblQuizTime: UILabel!
    
    @IBOutlet var lblQuizStartTime: UILabel!
    @IBOutlet var lblQuizEndTime: UILabel!
    
    @IBOutlet var lblQuizName: MarqueeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
