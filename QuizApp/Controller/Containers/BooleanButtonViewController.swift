//
//  BooleanButtonViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit
import AVFoundation

protocol BooleanButtonViewControllerDelegate {
    func submittedAnswer(answer: String)
}

class BooleanButtonViewController: UIViewController {
    
    @IBOutlet weak var buttons0: UIButton!
    @IBOutlet weak var buttons1: UIButton!
    
    // Define a collection for both buttons
    @IBOutlet var allButtons: [UIButton]!
    
    // Set up delegate so this class can call a method in GameViewController for when the button is pressed.
    var delegate: BooleanButtonViewControllerDelegate?
    
    // Create an array for possible answers with the text for the label and the correct bool for if it is correct or not
    // Used for UI colours
    var answers: [Answers] = [Answers(text: "", correct: false),
                              Answers(text: "", correct: false)]
        
    var selectedAnswer: UIButton?
    
    var correctSound: AVAudioPlayer?
    var wrongSound: AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let correctSoundPath = Bundle.main.path(forResource: "correct", ofType: "mp3") {
            let url = URL(fileURLWithPath: correctSoundPath)
            do {
                correctSound = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Error loading correct sound file: \(error.localizedDescription)")
            }
        }
        
        if let wrongSoundPath = Bundle.main.path(forResource: "false", ofType: "mp3") {
            let url = URL(fileURLWithPath: wrongSoundPath)
            do {
                wrongSound = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Error loading wrong sound file: \(error.localizedDescription)")
            }
        }
        
        correctSound?.prepareToPlay()
        wrongSound?.prepareToPlay()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        // Use this to block any sequential button presses after the first
        // Stops buttons being pressed for next questions
        if selectedAnswer == nil {
            selectedAnswer = sender
        } else {
            return
        }
        
        
        // Check if the answer was correct and change UI accordingly
        for answer in self.answers {
            if sender.currentTitle == answer.text {
                if answer.correct == true {
                    DispatchQueue.main.async {
                        sender.backgroundColor = UIColor.green
                        sender.setTitleColor(UIColor.black, for: .normal)
                    }
                    correctSound?.play()
                } else {
                    DispatchQueue.main.async {
                        sender.backgroundColor = UIColor.red
                        sender.setTitleColor(UIColor.black, for: .normal)
                    }
                    wrongSound?.play()
                }
            }
        }
        
        // Set a timer to a function to send the answer and change UI back to normal
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendAnswer), userInfo: nil, repeats: false)
    }
    
    @objc func sendAnswer(){
        // Submit answer to GameViewController
        delegate?.submittedAnswer(answer: selectedAnswer!.currentTitle!)
        
        // Set UI back to normal
        DispatchQueue.main.async {
            self.buttons0.backgroundColor = UIColor.black
            self.buttons0.setTitleColor(UIColor.white, for: .normal)
            
            self.buttons1.backgroundColor = UIColor.black
            self.buttons1.setTitleColor(UIColor.white, for: .normal)
        }
    }
}

extension BooleanButtonViewController: GameViewControllerDelegate {
    func clearUI() {
        // Not required since true and false stay in the same buttons
    }
    
    // Allow GameViewController to update Answers a
    func updateUI(answers: [Answers]) {
        self.answers = answers
        
        // Allow user to press and submit a button again
        selectedAnswer = nil
        
//        DispatchQueue.main.async {
//            for button in self.allButtons {
//                button.isEnabled = true
//            }
//        }
    }
}
