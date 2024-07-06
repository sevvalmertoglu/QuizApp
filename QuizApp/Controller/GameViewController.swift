//
//  GameViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import UIKit

protocol GameViewControllerDelegate {
    func updateUI(answers: [Answers])
    func clearUI()
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var multipleButtonsView: UIView!
    @IBOutlet weak var booleanButtonsView: UIView!
    
    @IBOutlet weak var quizLabel: UILabel!
    @IBOutlet weak var quizProgressView: UIProgressView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var settingsOptions: SettingsOptions?
    
    var gameManager = GameManager()
    var selectedCategoryName: String?
    var multipleDelegate: GameViewControllerDelegate?
    var booleanDelegate: GameViewControllerDelegate?
    
    private var activityIndicator: CustomActivityIndicator?
    
    // Hide navigationbar on the welcome screen
    override func viewWillAppear(_ animated: Bool) {
        // Always call super when overiding method from the super class
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        gameManager.delegate = self
    
    }
    
    // Unhide the navigation bar to show it on other screens
    override func viewWillDisappear(_ animated: Bool) {
        // Always call super when overiding method from the super class
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        if let safeSettingsOptions = settingsOptions {
            startLoading()
            print(safeSettingsOptions)
            gameManager.fetchQuizData(settingsOptions: safeSettingsOptions)
            self.stopLoading()
        }
       
    }
    
    private func setupActivityIndicator() {
          activityIndicator = CustomActivityIndicator(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
          activityIndicator?.center = self.view.center
          activityIndicator?.isHidden = true
          
          if let activityIndicator = activityIndicator {
              self.view.addSubview(activityIndicator)
          }
      }
      
      func startLoading() {
          activityIndicator?.startAnimating()
      }
      
      func stopLoading() {
          activityIndicator?.stopAnimating()
      }
    
    // Send data to view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.containers.showMultiple {
            let destinationVC = segue.destination as! MultipleButtonViewController
            destinationVC.delegate = self
            multipleDelegate = destinationVC
            
        } else if segue.identifier == K.segue.containers.showBoolean {
            let destinationVC = segue.destination as! BooleanButtonViewController
            destinationVC.delegate = self
            booleanDelegate = destinationVC
            
        } else if segue.identifier == K.segue.toGameOverVC {
            let destinationVC = segue.destination as! GameOverViewController

            print("Going to end screen now")
            destinationVC.total = settingsOptions!.numberOfQuestions
            destinationVC.correctNumber = gameManager.currentUserScore
        }
    }

    @objc func showMultiple(){
        DispatchQueue.main.async {
            self.booleanButtonsView.isHidden = true
            self.multipleButtonsView.isHidden = false
        }
    }
    
    @objc func showBoolean(){
        DispatchQueue.main.async {
            self.booleanButtonsView.isHidden = false
            self.multipleButtonsView.isHidden = true
        }
    }
    
    
}

//MARK: - GameManagerDelegate
extension GameViewController: GameManagerDelegate {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Return to selection screen", style: .default) { _ in
            self.performSegue(withIdentifier: K.segue.toTryGame, sender: self)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateTimeLabel(timeLeft: TimeInterval) {
        DispatchQueue.main.async {
            self.timeLabel.text = "\(Int(timeLeft))"
        }
    }
    
    func updateUI(uiData: UIData) {
        // Update main UI
        DispatchQueue.main.async{
            self.quizLabel.text = uiData.question.htmlAttributedString!.string
            self.quizProgressView.setProgress(uiData.percentage, animated: true)
        }
        
        // Update Button UI and show the correct view
        if uiData.type == "multiple" {
            multipleDelegate?.updateUI(answers: uiData.answers)
            showMultiple()
            
        } else {
            booleanDelegate?.updateUI(answers: uiData.answers)
            showBoolean()
        }
        
    }
    
    // Show screen at the end of the game
    func showEndScreen(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: K.segue.toGameOverVC, sender: self)
        }
    }
}

//MARK: - MultipleButtonViewControllerDelegate
// Extension used by two protocols to return data from the button viewcontrollers to the main gameManger instance.
extension GameViewController: MultipleButtonViewControllerDelegate, BooleanButtonViewControllerDelegate {
    func submittedAnswer(answer: String) {
        gameManager.questionAnswer(answer: answer)
    }
}
