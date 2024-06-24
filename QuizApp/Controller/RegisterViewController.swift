//
//  RegisterViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 13.06.2024.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameSurnameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var registerMailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if let email = registerMailTextField.text, let password = registerPasswordTextField.text,
           !email.isEmpty, !password.isEmpty {
            
            Auth.auth().createUser(withEmail: email, password: password) { authData, error in
                if let error = error {
                    self.makeAlert(titleInput: "ERROR", messageInput: error.localizedDescription)
                } else {
                    if let userId = authData?.user.uid {
                        let name = self.nameSurnameTextField.text ?? ""
                        let nickname = self.nicknameTextField.text ?? ""
                        
                        // Create User object
                        let user = User(name: name, nickname: nickname, email: email, Scores: [])
                        
                        // Save user to Firebase Realtime Database
                        self.saveUserToFirebase(userId: userId, user: user)
                    }
                }
            }
        } else {
            makeAlert(titleInput: "ERROR", messageInput: "Please enter your email and password")
        }
    }
    
    func saveUserToFirebase(userId: String, user: User) {
        let ref = Database.database().reference()
        
        ref.child("users").child(userId).setValue([
            "name": user.name,
            "nickname": user.nickname,
            "email": user.email,
            "scores": user.Scores.map { score -> [String: Any] in
                return [
                    "date": score.date,
                    "score": score.score
                ]
            }
        ]) { (error, ref) in
            if let error = error {
                self.makeAlert(titleInput: "ERROR", messageInput: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "toNumberOfQuestionsVC", sender: nil)
            }
        }
    }
    

}

