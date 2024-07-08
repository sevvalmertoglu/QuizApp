//
//  UserProfileViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit
import FirebaseAuth

class UserProfileViewController: UIViewController  {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var totalScoreView: UIView!
    
    var user: User?
    
    private var activityIndicator: CustomActivityIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage(imageName: "background3")
    
        nicknameView.applyCornerRadiusWithShadow()
        mailView.applyCornerRadiusWithShadow()
        totalScoreView.applyCornerRadiusWithShadow()
        backgroundView.applyCornerRadiusWithShadow()
       
        setupActivityIndicator()
        fetchCurrentUser()
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
    
    func fetchCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        startLoading()
        FirebaseManager.shared.fetchUserData(userId: userId) { [weak self] result in
            self?.stopLoading()
            switch result {
            case .success(let user):
                self?.user = user
                self?.updateUI()
                self?.fetchProfileIcon(userId: userId)
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
       
    }

    func updateUI() {
        guard let user = user else { return }
        nameLabel.text = user.name
        nicknameLabel.text = user.nickname
        mailLabel.text = user.email
    }
    
    func fetchProfileIcon(userId: String) {
        startLoading()
        FirebaseManager.shared.fetchUserIcon(userId: userId) { [weak self] result in
            self?.stopLoading()
            switch result {
            case .success(let iconName):
                self?.userProfileImageView.image = UIImage(named: iconName) ?? UIImage(named: "user")
            case .failure(let error):
                self?.makeAlert(titleInput: "ERORR!", messageInput: "Profile icon failed to load: \(error.localizedDescription)")
                print("Error fetching profile icon: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func exitButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("error")
        }
    }
    
    @IBAction func userIconButton(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toUserIconVC , sender: self)
    }
    
    
    @IBAction func previousScoresButton(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toPreviousScoresVC, sender: self)
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        guard let email = user?.email else {
            makeAlert(titleInput: "Error", messageInput: "User email address not found.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.makeAlert(titleInput: "Error", messageInput: "Error sending password reset email: \(error.localizedDescription)")
            } else {
                self.makeAlert(titleInput: "Successful!", messageInput: "Password reset email has been sent successfully.")
            }
        }
    }
    
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        guard let userId = Auth.auth().currentUser?.uid else {
            makeAlert(titleInput: "Error", messageInput: "User not authenticated.")
            return
        }
        
        let user = Auth.auth().currentUser
        startLoading()
      
            user?.delete { error in
                self.stopLoading()
                if let error = error {
                    self.makeAlert(titleInput: "ERROR", messageInput: "Error while deleting account: \(error.localizedDescription)")
                } else {
                    let alert = UIAlertController(title: "Successful", message: "The account has been successfully deleted.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        FirebaseManager.shared.deleteUserData(userId: userId) { error in
                            if let error = error {
                                self.stopLoading()
                                self.makeAlert(titleInput: "ERROR", messageInput: "Error while deleting user data: \(error.localizedDescription)")
                                return
                            }
                        }
                        self.performSegue(withIdentifier: "toViewController", sender: nil)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        
        
        
    }
    
}
extension UIViewController {
    func setBackgroundImage(imageName: String) {
        let backgroundImage = UIImage(named: imageName)
        let backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.frame = self.view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
}
