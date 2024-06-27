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
        guard let email = registerMailTextField.text, let password = registerPasswordTextField.text, !email.isEmpty, !password.isEmpty else {
            makeAlert(titleInput: "ERROR", messageInput: "Please enter your email and password")
            return
        }
        
        let name = nameSurnameTextField.text ?? ""
        let nickname = nicknameTextField.text ?? ""
        
        FirebaseManager.shared.register(email: email, password: password, name: name, nickname: nickname) { result in
            switch result {
            case .success(let user):
                print("User registered: \(user)")
                self.performSegue(withIdentifier: "toNumberOfQuestionsVC", sender: nil)
            case .failure(let error):
                self.makeAlert(titleInput: "ERROR", messageInput: error.localizedDescription)
            }
        }
    }
    
    
}

