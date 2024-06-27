//
//  User.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 24.06.2024.
//

import Foundation

struct User {
    var name: String
    var nickname: String
    var email: String
    var Scores: [Score]
//    var TotalScores: [TotalScores]

}

struct Score: Codable {
    let date: String
//    let difficulty: String
//    let topic: String
    let score: Int
}

//struct TotalScores: Codable {
//    let totalScore: Int
//}
