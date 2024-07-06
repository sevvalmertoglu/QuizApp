//
//  PreviousScoresViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 5.07.2024.
//

import UIKit
import FirebaseAuth

class PreviousScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userScoresTableView: UITableView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userScoresTableView.delegate = self
        userScoresTableView.dataSource = self
 
        CurrentUser()
    }
    
    func CurrentUser() {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            FirebaseManager.shared.fetchUserData(userId: userId) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.userScoresTableView.reloadData()
                case .failure(let error):
                    print("Error fetching user data: \(error.localizedDescription)")
                }
            }
        }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.Scores.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userScoresCell", for: indexPath) as! UserScoresTableViewCell
        if let score = user?.Scores[indexPath.row] {
            cell.dateLabel.text = score.date
            cell.pointLabel.text = "\(score.score)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
