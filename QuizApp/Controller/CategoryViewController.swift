//
//  CategoryViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var easyLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var hardLabel: UILabel!
    
    var settingsOptions: SettingsOptions?
    var categories: CategoryData?
    var categoriesManager: CategoriesManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self

        categoriesManager?.delegate = self
        
        categoryNameLabel.text = categories?.trivia_categories[settingsOptions!.category].name
        print(settingsOptions!)
    
    }

    @IBAction func categoryNextButton(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toTypeVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.toTypeVC {
            let destinationVC = segue.destination as! TypeViewController //Chose the right view controller. - Downcasting
            destinationVC.settingsOptions = settingsOptions
        }
    }

}

//MARK: - UIPickerView
extension CategoryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (categories?.trivia_categories.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories?.trivia_categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = categories?.trivia_categories[row].name
        settingsOptions?.category = categories!.trivia_categories[row].id
        if settingsOptions?.category != 0 {
            categoriesManager!.getCategoriesStats(catId: settingsOptions!.category)
        } else {
            DispatchQueue.main.async {
                self.easyLabel.text = ""
                self.mediumLabel.text = ""
                self.hardLabel.text = ""
            }
        }

        categoryNameLabel.text = selectedOption

    }
}

extension CategoryViewController: CategoriesManagerDelegate {
    func updateCategoryStatsLabels() {
        DispatchQueue.main.async {
            self.totalLabel.text = "Total: \(self.categoriesManager!.categoryStats!.category_question_count.total_question_count)"
            self.easyLabel.text = "Easy: \(self.categoriesManager!.categoryStats!.category_question_count.total_easy_question_count)"
            self.mediumLabel.text = "Medium: \(self.categoriesManager!.categoryStats!.category_question_count.total_medium_question_count)"
            self.hardLabel.text = "Hard: \(self.categoriesManager!.categoryStats!.category_question_count.total_hard_question_count)"
        }
    }
}
