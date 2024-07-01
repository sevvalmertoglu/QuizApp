//
//  GameOverViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class GameOverViewController: UIViewController {
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var correctNumber: Int?
    var total: Int?
    var user: User?
    var nickname: String?
    var totalScoreFromScores: Int = 0
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Change some data to show the users score and game settings
        print("did load")
        if let safeCorrectNumber = correctNumber {
            if let safeTotal = total {
                scoreLabel.text = "\(safeCorrectNumber)/\(safeTotal)"
                saveScore(score: safeCorrectNumber * 100)
            }
        }
        
    }
    
    @IBAction func tryAgainClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toTryAgain , sender: self)
    }
    
    @IBAction func scoresClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toScores , sender: self)
    }
    
    

    
    private func saveScore(score: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let scoreData = Score(date: FirebaseManager.shared.getCurrentDate(), score: score)
        FirebaseManager.shared.saveScore(userId: userId, score: scoreData) { result in
            switch result {
            case .success:
                print("Score saved successfully!")
            case .failure(let error):
                print("Error saving score: \(error.localizedDescription)")
            }
        }
    }
    
}


