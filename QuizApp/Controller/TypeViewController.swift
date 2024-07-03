//
//  TypeViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit

class TypeViewController: UIViewController {
    
    var settingsOptions: SettingsOptions?
    var selectedCategoryName: String?
    
    @IBOutlet var allTypeButtons: [UIButton]!
    @IBOutlet var allDifficultyButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeSettingsOptions = settingsOptions {
            print(safeSettingsOptions)
        }
        
        for button in allTypeButtons {
            button.layer.cornerRadius = 15
        }
        
        for button in allDifficultyButtons {
            button.layer.cornerRadius = 15
        }
    }
    
    
    @IBAction func allTypeButtonsClicked(_ sender: UIButton) {
        var questionTypeSelected: String?
        
        updateButtonSelections(selectedButton: sender)
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.layer.cornerRadius = 15
        
        switch(sender.tag){
            
        case 1:
            questionTypeSelected = nil
        case 2:
            questionTypeSelected = "boolean"
        case 3:
            questionTypeSelected = "multiple"
        default:
            print("ERROR")
        }
        
        settingsOptions?.type = questionTypeSelected
    }
    
    func updateButtonSelections(selectedButton: UIButton) {
        // Tüm butonlar için varsayılan renk
        let defaultColor = UIColor.darkPurple
        // Seçili buton için renk
        let selectedColor = UIColor.lightPurple

        // Tüm butonları varsayılan renge çevir
        allTypeButtons.forEach { button in
            button.backgroundColor = defaultColor
        }

        // Seçili butonun rengini değiştir
        selectedButton.backgroundColor = selectedColor
    }
    
    @IBAction func allDifficultyButtonsClicked(_ sender: UIButton) {
        
        updateDifficultyButtonSelections(selectedButton: sender)
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.layer.cornerRadius = 15
        
        
        switch(sender.tag){
        case 4:
            settingsOptions?.difficulty = "easy"
            break
        case 5:
            settingsOptions?.difficulty = "medium"
            break
        case 6:
            settingsOptions?.difficulty = "hard"
            break
        default:
            settingsOptions?.difficulty = nil
        }
    }
    
    func updateDifficultyButtonSelections(selectedButton: UIButton) {
        // Tüm butonlar için varsayılan renk
        let defaultColor = UIColor.darkPurple
        // Seçili buton için renk
        let selectedColor = UIColor.lightPurple

        // Tüm butonları varsayılan renge çevir
        allDifficultyButtons.forEach { button in
            button.backgroundColor = defaultColor
        }

        // Seçili butonun rengini değiştir
        selectedButton.backgroundColor = selectedColor
    }
    
    
    
    
    @IBAction func startButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.segue.toGameVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.toGameVC {
            let destinationVC = segue.destination as! GameViewController //Chose the right view controller. - Downcasting
            destinationVC.settingsOptions = settingsOptions
       
    
        }
    }
    
    
    

}
