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
            button.backgroundColor = UIColor.darkPurple
            button.setTitleColor(UIColor.white, for: .normal)
            
        }
        
        for button in allDifficultyButtons {
            button.layer.cornerRadius = 15
            button.backgroundColor = UIColor.lightPurple
            button.setTitleColor(UIColor.white, for: .normal)
            
        }
    }
    
    
    @IBAction func allTypeButtonsClicked(_ sender: UIButton) {
        var questionTypeSelected: String?
        
        sender.backgroundColor = UIColor.systemIndigo
        sender.setTitleColor(UIColor.black, for: .normal)
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
    
    
    @IBAction func allDifficultyButtonsClicked(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.systemIndigo
        sender.setTitleColor(UIColor.black, for: .normal)
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
