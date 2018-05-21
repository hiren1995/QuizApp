//
//  MyQuizleaderboardTableViewCell.swift
//  QuizApp
//
//  Created by Apple on 17/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MarqueeLabel

class MyQuizleaderboardTableViewCell: UITableViewCell {

    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblCompletionTime: UILabel!
    @IBOutlet var lblLevel: UILabel!
    //@IBOutlet var lblWonLoose: UILabel!
    @IBOutlet var imgTrophy: UIImageView!
    @IBOutlet var ViewCell: UIView!
    @IBOutlet var lblWonLoose: MarqueeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
