//
//  ParticularQuizTableViewCell.swift
//  QuizApp
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MarqueeLabel

class ParticularQuizTableViewCell: UITableViewCell {
    
    @IBOutlet var imgUser: UIImageView!
    //@IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblCompletionTime: UILabel!
    @IBOutlet var lblLevel: UILabel!
    @IBOutlet var lblUserName: MarqueeLabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
