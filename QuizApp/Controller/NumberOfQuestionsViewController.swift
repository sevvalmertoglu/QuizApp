//
//  NumberOfQuestionsViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 13.06.2024.
//

import UIKit

class NumberOfQuestionsViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberOfQuestionsStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "toCategoryVC", sender: nil)
    }
    
}
