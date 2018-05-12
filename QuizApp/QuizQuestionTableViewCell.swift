//
//  QuizQuestionTableViewCell.swift
//  QuizApp
//
//  Created by Apple on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class QuizQuestionTableViewCell: UITableViewCell {

    @IBOutlet var lblQuestionNo: UILabel!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var btnOptionA: UIButton!
    @IBOutlet var btnOptionB: UIButton!
    @IBOutlet var btnOptionC: UIButton!
    @IBOutlet var btnOptionD: UIButton!
    @IBOutlet var imgOptionA: UIImageView!
    @IBOutlet var imgOptionB: UIImageView!
    @IBOutlet var imgOptionC: UIImageView!
    @IBOutlet var imgOptionD: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
