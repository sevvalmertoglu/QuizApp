//
//  ScoresViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 24.06.2024.
//

import UIKit

class ScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var leadershipTableView: UITableView!
    
    
    @IBOutlet weak var firstPointLabel: UILabel!
    @IBOutlet weak var secondPointLabel: UILabel!
    @IBOutlet weak var thirdPointLabel: UILabel!
    
    @IBOutlet weak var firstPointView: UIView!
    @IBOutlet weak var secondPointView: UIView!
    @IBOutlet weak var thirdPointView: UIView!
    
    var leaderboard: [(nickname: String, totalScore: Int)] = []
    var topThree: [(nickname: String, totalScore: Int)] = []
    var topFourToTen: [(nickname: String, totalScore: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage(imageName: "background4")
        
        firstPointView.applyCornerRadiusWithShadow()
        secondPointView.applyCornerRadiusWithShadow()
        thirdPointView.applyCornerRadiusWithShadow()
        
        leadershipTableView.delegate = self
        leadershipTableView.dataSource = self
        
        fetchLeaderboard()
    }
    
    func fetchLeaderboard() {
        FirebaseManager.shared.fetchLeaderboard { [weak self] result in
            switch result {
            case .success(let leaderboard):
                self?.leaderboard = leaderboard
                self?.updateUI()
            case .failure(let error):
                print("Error fetching leaderboard: \(error.localizedDescription)")
            }
        }
    }
    
    func updateUI() {
        if leaderboard.count > 0 {
            topThree = Array(leaderboard.prefix(3))
            topFourToTen = Array(leaderboard.dropFirst(3).prefix(7))
        }
        
        if topThree.count > 0 {
            firstLabel.text = "\(topThree[0].nickname)"
            firstPointLabel.text = "\(topThree[0].totalScore)"
        }
        
        if topThree.count > 1 {
            secondLabel.text = "\(topThree[1].nickname)"
            secondPointLabel.text = "\(topThree[1].totalScore)"
        }
        
        if topThree.count > 2 {
            thirdLabel.text = "\(topThree[2].nickname)"
            thirdPointLabel.text = "\(topThree[2].totalScore)"
        }
        
        leadershipTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topFourToTen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! leadershipTableViewCell
        let leaderboardEntry = topFourToTen[indexPath.row]
        cell.numberLabel.text = "\(indexPath.row + 4)"
        cell.nicknameLabel.text = leaderboardEntry.nickname
        cell.totalScoreLabel.text = "\(leaderboardEntry.totalScore)"
        return cell
    }
    
}

extension UIView {
    func applyCornerRadiusWithShadow(cornerRadius: CGFloat = 15.0, shadowColor: UIColor = .black, shadowOpacity: Float = 0.5, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowRadius: CGFloat = 4.0) {

        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    }
}
