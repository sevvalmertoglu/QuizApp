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
    
    private var activityIndicator: CustomActivityIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
          activityIndicator = CustomActivityIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
          activityIndicator?.center = self.view.center
          activityIndicator?.isHidden = true
          
          if let activityIndicator = activityIndicator {
              self.view.addSubview(activityIndicator)
          }
      }
      
      func startLoading() {
          activityIndicator?.startAnimating()
      }
      
      func stopLoading() {
          activityIndicator?.stopAnimating()
      }
    
    @IBAction func registerButton(_ sender: Any) {
        guard let email = registerMailTextField.text, let password = registerPasswordTextField.text, !email.isEmpty, !password.isEmpty else {
            makeAlert(titleInput: "ERROR", messageInput: "Please enter your email and password")
            return
        }
        
        let name = nameSurnameTextField.text ?? ""
        let nickname = nicknameTextField.text ?? ""
        
        startLoading()
        FirebaseManager.shared.register(email: email, password: password, name: name, nickname: nickname) { result in
            self.stopLoading()
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

