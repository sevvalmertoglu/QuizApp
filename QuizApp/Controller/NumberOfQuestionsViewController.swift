//
//  NumberOfQuestionsViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 13.06.2024.
//

import UIKit

class NumberOfQuestionsViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    var settingsOptions = SettingsOptions()
    
    @IBOutlet weak var numberOfQuestionsStepper: UIStepper!
    
    let categoriesManager = CategoriesManager()
    var categories: CategoryData?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfQuestionsStepper.value = 10
        settingsOptions.numberOfQuestions = 10

        categoriesManager.getCategories()

    }
    
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        settingsOptions.numberOfQuestions = Int(sender.value)
        numberLabel.text = String(format: "%.0f", sender.value)
    }
    

    @IBAction func nextButton(_ sender: Any) {
        categories = categoriesManager.categories
        self.performSegue(withIdentifier: K.segue.toCategoryVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.toCategoryVC {
            let destinationVC = segue.destination as! CategoryViewController //Chose the right view controller. - Downcasting
            
            destinationVC.settingsOptions = settingsOptions
            destinationVC.categories = categories
            destinationVC.categoriesManager = categoriesManager
        }
    }
}
