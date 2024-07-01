//
//  GameManager.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import Foundation

protocol GameManagerDelegate {
    func updateUI(uiData: UIData)
    func showEndScreen()
    func updateTimeLabel(timeLeft: TimeInterval)
}

class GameManager {
    
    var delegate: GameManagerDelegate?
    
    var quizData: QuizData?
    
    var settingsOptions: SettingsOptions?
    
    var currentQuestion: QuestionData?
    var currentQuestionNumber: Int = 0
    var currentUserScore: Int = 0
    
    var timer: Timer?
    var timeLeft: TimeInterval = 10
    
    /// Starts the timer for the quiz with a 10 second countdown.
    func startTimer() {
           timer?.invalidate()
           timeLeft = 10
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
       }
    
    /// Updates the remaining time for the current question.
    /// If time is up and it's not the last question, it moves to the next question.
    @objc func timerTick() {
        timeLeft -= 1
        delegate?.updateTimeLabel(timeLeft: timeLeft)
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            // Time is up
            if currentQuestionNumber < (settingsOptions?.numberOfQuestions ?? 1) - 1 {
                nextQuestion()
            }
        }
    }
    
    /// Fetches quiz data from the API based on the provided settings options and starts the game.
    /// - Parameter settingsOptions: The settings options chosen by the user.
    func fetchQuizData(settingsOptions: SettingsOptions){
        let quizURL = generateURL(settingsOptions: settingsOptions)
        self.settingsOptions = settingsOptions
        
        if let url = URL(string: quizURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(QuizData.self, from: safeData)
                            self.quizData = results

                            //To run on main thread
                            DispatchQueue.main.async {
                                self.nextQuestion()
                            }
                            
                        } catch {
                            print(error)
                        }
                    }
                }
            }
       
            task.resume()
        }
    }
    
    /// Displays the next question and sends the data to the view controller.
    func nextQuestion(){
        // Check the current number is under the max
        if let safeNumberOfQuestions = settingsOptions?.numberOfQuestions {
            if currentQuestionNumber < safeNumberOfQuestions {
                
                if quizData?.results.count == 0 {
                    delegate?.showEndScreen()
                } else {
                    // Increment the current question
                    currentQuestion = quizData?.results[currentQuestionNumber]
                    if let safeQuestion = currentQuestion?.question {
                        
                        var answerArray: [Answers] // Create answer array
                        
                        // Populate the array based on the number of
                        if currentQuestion?.type == "boolean" {
                            answerArray = [
                                Answers(text: currentQuestion!.correct_answer, correct: true),
                                Answers(text: currentQuestion!.incorrect_answers[0], correct: false),
                            ]
                        } else {
                            answerArray = [
                                Answers(text: currentQuestion!.correct_answer, correct: true),
                                Answers(text: currentQuestion!.incorrect_answers[0], correct: false),
                                Answers(text: currentQuestion!.incorrect_answers[1], correct: false),
                                Answers(text: currentQuestion!.incorrect_answers[2], correct: false),
                            ]
                        }
                        
                        answerArray.shuffle()
                        
                        let questionPercentage = Float(currentQuestionNumber+1) / Float(settingsOptions!.numberOfQuestions)
                        
                        print("Percentage: \(questionPercentage)")
                        
                        let uiData = UIData(question: safeQuestion,
                                            answers: answerArray,
                                            percentage: questionPercentage,
                                            type: currentQuestion!.type)
                        
                        // Start the timer for the new question
                        startTimer()
                        delegate?.updateUI(uiData: uiData)
                        print("QUESTION: \(safeQuestion)")
                       
                       
                    }
                    currentQuestionNumber += 1
                    
                }
                
            } else {
                print("Game Over")
                print("Your score is \(currentUserScore) / \(settingsOptions!.numberOfQuestions)")
                delegate?.showEndScreen()
            }
        }
        
    }
    
    /// Processes the user's answer and updates the score. Moves to the next question if applicable.
    /// - Parameter answer: The user's selected answer.
    func questionAnswer(answer: String) {
        if let safeIncorrectAnswers = currentQuestion?.incorrect_answers {
            if let safeCorrectAnswer = currentQuestion?.correct_answer {
                if (safeCorrectAnswer == answer || safeIncorrectAnswers.contains(answer)){
                    if answer == safeCorrectAnswer {
                        print("Correct Answer!")
                        currentUserScore += 1
                    } else {
                        print("Wrong Answer")
                    }
                    nextQuestion()
                }
            }
        }
    }
    
    /// Generates the URL for the quiz API request based on the provided settings options.
    /// - Parameter settingsOptions: The settings options chosen by the user.
    /// - Returns: The generated URL string.
    func generateURL(settingsOptions: SettingsOptions) -> String {
        var baseURL = "https://opentdb.com/api.php?"
        
        baseURL += "amount=\(settingsOptions.numberOfQuestions)"
        
        if settingsOptions.category != 0 {
            baseURL += "&category=\(settingsOptions.category)"
        }
        
        if let safeDifficulty = settingsOptions.difficulty {
            baseURL += "&difficulty=\(safeDifficulty)"
        }
        
        if let safeType = settingsOptions.type {
            baseURL += "&type=\(safeType)"
        }
        
        print("BASEURL: \(baseURL)")
        return baseURL
    }
    
   
}
