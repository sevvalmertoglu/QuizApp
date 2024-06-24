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
    var settingsOptions = SettingsOptions()
    var user: User?
//    var settingsOptions: SettingsOptions?
    var nickname: String?
    var totalScoreFromScores: Int = 0
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Change some data to show the users score and game settings
        if let safeCorrectNumber = correctNumber {
            if let safeTotal = total {
                scoreLabel.text = "\(safeCorrectNumber)/\(safeTotal)"
                saveScoreToFirebase(score: safeCorrectNumber * 100)
            }
        }
        
    }
    
    @IBAction func tryAgainClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toTryAgain , sender: self)
    }
    
    @IBAction func scoresClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toScores , sender: self)
    }
    
    func saveScoreToFirebase(score: Int) {
           guard let userId = Auth.auth().currentUser?.uid else { return } // Ensure user is logged in
           
           let scoreData = Score(
               date: getCurrentDate(),
               score: score
           )
           let scoreDict = try! DictionaryEncoder().encode(scoreData)
           
           let dbRef = Database.database().reference()
           let userScoresRef = dbRef.child("users").child(userId).child("scores")
           
           userScoresRef.childByAutoId().setValue(scoreDict) { (error, ref) in
               if let error = error {
                   print("Error saving score: \(error.localizedDescription)")
               } else {
                   print("Score saved successfully!")
//                   self.updateTotalScore(userId: userId, score: score)
               }
           }
       }
  

    func getCurrentDate() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          return dateFormatter.string(from: Date())
      }
   
}

struct DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try jsonEncoder.encode(value)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = jsonObject as? [String: Any] else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: ""))
        }
        return dictionary
    }
}
