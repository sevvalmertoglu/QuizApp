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
        if registerMailTextField.text != "" && registerPasswordTextField.text != "" {
                 Auth.auth().createUser(withEmail: registerMailTextField.text!, password: registerPasswordTextField.text!) {authdata, error in
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

