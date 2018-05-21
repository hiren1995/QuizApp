//
//  GlobalQuizTableViewCell.swift
//  QuizApp
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MarqueeLabel

class GlobalQuizTableViewCell: UITableViewCell {

    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblCompletionTime: UILabel!
    @IBOutlet var lblLevel: UILabel!
    //@IBOutlet var lblQuizName: UILabel!
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
