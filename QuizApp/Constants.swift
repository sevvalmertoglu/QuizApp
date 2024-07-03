//
//  Constants.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import Foundation

struct K {
    static let appName = "Quiz App!"
    
    struct segue {
        static let toNumberOfQuestionsVC = "toNumberOfQuestionsVC"
        static let toCategoryVC = "toCategoryVC"
        static let toTypeVC = "toTypeVC"
        static let toGameVC = "toGameVC"
        static let toGameOverVC = "toGameOverVC"
        static let toTryAgain = "toTryAgain"
        static let toScores = "toScores"
        static let toUserIconVC = "toUserIconVC"
        static let toTryGame = "toTryGame"
        struct containers {
            static let showMultiple = "showMultiple"
            static let showBoolean = "showBoolean"
        }
    }
}
