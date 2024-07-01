//
//  UserScoresTableViewCell.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 1.07.2024.
//

import UIKit

class UserScoresTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
