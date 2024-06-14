//
//  TypeViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit

class TypeViewController: UIViewController {
    
    var settingsOptions: SettingsOptions?
    
    @IBOutlet var allTypeButtons: [UIButton]!
    @IBOutlet var allDifficultyButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeSettingsOptions = settingsOptions {
            print(safeSettingsOptions)
        }
    }
    
    
    @IBAction func allTypeButtonsClicked(_ sender: UIButton) {
        var questionTypeSelected: String?
        
        switch(sender.currentTitle){
        case "TRUE / FALSE":
            questionTypeSelected = "boolean"
            break
        case "MULTIPLE CHOICE":
            questionTypeSelected = "multiple"
            break
        case "BOTH":
            questionTypeSelected = nil
            break
        default:
            print("ERROR")
        }
        
        settingsOptions?.type = questionTypeSelected
    }
    
    
    @IBAction func allDifficultyButtonsClicked(_ sender: UIButton) {
        
        switch(sender.currentTitle){
        case "Easy":
            settingsOptions?.difficulty = "easy"
            break
        case "Medium":
            settingsOptions?.difficulty = "medium"
            break
        case "Hard":
            settingsOptions?.difficulty = "hard"
            break
        default:
            print("error")
            settingsOptions?.difficulty = nil
        }
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
