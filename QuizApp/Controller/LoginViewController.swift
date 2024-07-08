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

    @IBAction func loginButton(_ sender: Any) {
        guard let email = mailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
                   makeAlert(titleInput: "ERROR", messageInput: "Please enter your email and password")
                   return
               }

               startLoading()
               FirebaseManager.shared.signIn(email: email, password: password) { result in
                   self.stopLoading()
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
