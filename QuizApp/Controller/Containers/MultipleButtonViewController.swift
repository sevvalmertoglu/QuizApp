//
//  MultipleButtonViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit
import AVFoundation

protocol MultipleButtonViewControllerDelegate {
    func submittedAnswer(answer: String)
}

class MultipleButtonViewController: UIViewController {
    
    @IBOutlet weak var buttons0: UIButton!
    @IBOutlet weak var buttons1: UIButton!
    @IBOutlet weak var buttons2: UIButton!
    @IBOutlet weak var buttons3: UIButton!
    
    @IBOutlet var allButtons: [UIButton]!
    
    var selectedAnswer: UIButton?
        
    var delegate: MultipleButtonViewControllerDelegate?
    var answers: [Answers] = [Answers(text: "", correct: false),
                              Answers(text: "", correct: false),
                              Answers(text: "", correct: false),
                              Answers(text: "", correct: false)
    ]
    
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
        
        // Block multiple button presses
        if selectedAnswer == nil {
            selectedAnswer = sender
        } else {
            return
        }
        
        // Check if the answer was correct and change UI accordingly
              var correctAnswerButton: UIButton?
              for (index, answer) in self.answers.enumerated() {
                  if sender.currentTitle == answer.text {
                      if answer.correct {
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
                  if answer.correct {
                      correctAnswerButton = allButtons[index]
                  }
              }
              
              // If the selected answer is incorrect, highlight the correct answer button
              if let correctButton = correctAnswerButton, sender != correctButton {
                  DispatchQueue.main.async {
                      correctButton.backgroundColor = UIColor.green
                      correctButton.setTitleColor(UIColor.black, for: .normal)
                  }
              }
        
        // Set a timer to a function to send the answer and change UI back to normal
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendAnswer), userInfo: nil, repeats: false)
    }
    
    @objc func sendAnswer(){
            delegate?.submittedAnswer(answer: selectedAnswer!.currentTitle!)
            DispatchQueue.main.async {
                for button in self.allButtons {
                    button.backgroundColor = UIColor.black
                    button.setTitleColor(UIColor.white, for: .normal)
                }
                self.selectedAnswer = nil
            }
        }
}

extension MultipleButtonViewController: GameViewControllerDelegate {
    func updateUI(answers: [Answers]) {
        self.answers = answers
        DispatchQueue.main.async {
            
            self.buttons0.setTitle(answers[0].text.htmlAttributedString!.string, for: .normal)
            self.buttons1.setTitle(answers[1].text.htmlAttributedString!.string, for: .normal)
            self.buttons2.setTitle(answers[2].text.htmlAttributedString!.string, for: .normal)
            self.buttons3.setTitle(answers[3].text.htmlAttributedString!.string, for: .normal)
            self.selectedAnswer = nil
        }
    }
    
    func clearUI(){
        DispatchQueue.main.async {
            self.buttons0.setTitle("A", for: .normal)
            self.buttons1.setTitle("A", for: .normal)
            self.buttons2.setTitle("A", for: .normal)
            self.buttons3.setTitle("A", for: .normal)
        }
    }
}
