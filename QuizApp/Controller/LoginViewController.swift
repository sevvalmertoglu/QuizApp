//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 13.06.2024.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func loginButton(_ sender: Any) {
        if mailTextField.text != "" && passwordTextField.text != "" {
                  Auth.auth().signIn(withEmail: mailTextField.text!, password: passwordTextField.text!) { authdata, error in
                      if error != nil {
                          self.makeAlert(titleInput: "ERROR", messageInput:error?.localizedDescription ?? "Error")
                      } else {
                          self.performSegue(withIdentifier: "toNumberOfQuestionsVC", sender: nil)
                      }
                  }
              } else {
                  makeAlert(titleInput: "ERROR", messageInput: "Please enter your email and password")
              }
        
    }
    

}
