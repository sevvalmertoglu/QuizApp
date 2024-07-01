//
//  UserProfileViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit
import FirebaseAuth

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userScoresTableView: UITableView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userScoresTableView.delegate = self
        userScoresTableView.dataSource = self
        
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.shared.fetchUserData(userId: userId) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.updateUI()
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    func updateUI() {
        guard let user = user else { return }
        nameLabel.text = user.name
        userScoresTableView.reloadData()
    }

    @IBAction func exitButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.Scores.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userScoresCell", for: indexPath) as! UserScoresTableViewCell
        if let score = user?.Scores[indexPath.row] {
            cell.dateLabel.text = score.date
            cell.pointLabel.text = "\(score.score)"
        }
        return cell
    }
    
    
}
