//
//  GameOverViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit

class GameOverViewController: UIViewController {
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var correctNumber: Int?
    var total: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Change some data to show the users score and game settings
        if let safeCorrectNumber = correctNumber {
            if let safeTotal = total {
                scoreLabel.text = "\(safeCorrectNumber)/\(safeTotal)"
            }
        }

    }
    
    @IBAction func tryAgainClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toTryAgain , sender: self)
    }
    
    @IBAction func scoresClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toScores , sender: self)
    }
   
}
