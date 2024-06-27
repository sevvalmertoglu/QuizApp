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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leadershipTableView.delegate = self
        leadershipTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! leadershipTableViewCell
        cell.numberLabel.text = "\(indexPath.row + 4)"
        return cell
    }
    
}

