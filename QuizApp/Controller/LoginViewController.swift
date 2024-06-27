//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 13.06.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func loginButton(_ sender: Any) {
        guard let email = mailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
                   makeAlert(titleInput: "ERROR", messageInput: "Please enter your email and password")
                   return
               }

               FirebaseManager.shared.signIn(email: email, password: password) { result in
                   switch result {
                   case .success(let user):
                       print("User logged in: \(user)")
                       self.performSegue(withIdentifier: "toNumberOfQuestionsVC", sender: nil)
                   case .failure(let error):
                       self.makeAlert(titleInput: "ERROR", messageInput: error.localizedDescription)
                   }
               }
        
    }
    

}
