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
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var pointView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateView.applyCornerRadiusWithShadow()
        pointView.applyCornerRadiusWithShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
