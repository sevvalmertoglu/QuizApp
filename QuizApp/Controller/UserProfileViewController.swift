//
//  UserProfileViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit
import FirebaseAuth

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func exitButton(_ sender: Any) {
        do {
                  try Auth.auth().signOut()
                  self.performSegue(withIdentifier: "toViewController", sender: nil)
              } catch {
                  print("error")
              }
    }
    
}
