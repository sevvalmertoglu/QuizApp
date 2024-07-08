//
//  GameManager.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 26.06.2024.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FirebaseManager {

    static let shared = FirebaseManager()
    private let dbRef = Database.database().reference()

    private init() { }

    // MARK: - Authentication Methods

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                self.fetchUserData(userId: user.uid, completion: completion)
            }
        }
    }

    func register(email: String, password: String, name: String, nickname: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                let userData = ["name": name, "nickname": nickname, "email": email]
                self.dbRef.child("users").child(user.uid).setValue(userData) { error, _ in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        let newUser = User(name: name, nickname: nickname, email: email, Scores: [])
                        completion(.success(newUser))
                    }
                }
            }
        }
    }

    // MARK: - Database Methods

    func saveScore(userId: String, score: Score, completion: @escaping (Result<Void, Error>) -> Void) {
        let scoreDict = try! DictionaryEncoder().encode(score)
        dbRef.child("users").child(userId).child("scores").childByAutoId().setValue(scoreDict) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
//                completion(.success(()))
                self.updateTotalScore(userId: userId, score: score.score, completion: completion)
            }
        }
    }
    
    private func updateTotalScore(userId: String, score: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = dbRef.child("users").child(userId)
        userRef.runTransactionBlock({ currentData in
            if var user = currentData.value as? [String : Any] {
                var totalScore = user["totalScore"] as? Int ?? 0
                totalScore += score
                user["totalScore"] = totalScore
                currentData.value = user
                self.updateLeaderboard(userId: userId, nickname: user["nickname"] as? String ?? "", totalScore: totalScore)
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { error, committed, _ in
            if let error = error {
                completion(.failure(error))
            } else if committed {
                completion(.success(()))
            }
        }
    }
    
    private func updateLeaderboard(userId: String, nickname: String, totalScore: Int) {
        dbRef.child("leaderboard").child(userId).setValue(["nickname": nickname, "totalScore": totalScore])
    }
    
    func fetchUserData(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        dbRef.child("users").child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any],
                  let name = value["name"] as? String,
                  let nickname = value["nickname"] as? String,
                  let email = value["email"] as? String else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data is malformed."])))
                return
            }
            var scores: [Score] = []
            if let scoresData = value["scores"] as? [String: [String: Any]] {
                scores = scoresData.compactMap { key, value in
                    if let date = value["date"] as? String, let score = value["score"] as? Int {
                        return Score(date: date, score: score)
                    }
                    return nil
                }
            }
            let user = User(name: name, nickname: nickname, email: email, Scores: scores)
            completion(.success(user))
        }
    }
    
    func fetchLeaderboard(completion: @escaping (Result<[(nickname: String, totalScore: Int, userId: String)], Error>) -> Void) {
        dbRef.child("leaderboard").queryOrdered(byChild: "totalScore").observeSingleEvent(of: .value) { snapshot in
            var leaderboard: [(nickname: String, totalScore: Int, userId: String)] = []
            for child in snapshot.children.reversed() {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let nickname = value["nickname"] as? String,
                   let totalScore = value["totalScore"] as? Int {
                    let userId = snapshot.key
                    leaderboard.append((nickname: nickname, totalScore: totalScore, userId: userId))
                }
            }
            completion(.success(leaderboard))
        } withCancel: { error in
            completion(.failure(error))
        }
    }

    
    func saveUserIcon(userId: String, iconName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        dbRef.child("users").child(userId).child("profileIcon").setValue(iconName) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchUserIcon(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        dbRef.child("users").child(userId).child("profileIcon").observe(.value) { snapshot in
            if let iconName = snapshot.value as? String {
                completion(.success(iconName))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Icon not found."])))
            }
        }
    }
    
    func deleteUserData(userId: String, completion: @escaping (Error?) -> Void) {
            let userRef = dbRef.child("users").child(userId)
            userRef.removeValue { error, _ in
                completion(error)
            }
        }

    // MARK: - Helper Methods
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}

struct DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try jsonEncoder.encode(value)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = jsonObject as? [String: Any] else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: ""))
        }
        return dictionary
    }
}

