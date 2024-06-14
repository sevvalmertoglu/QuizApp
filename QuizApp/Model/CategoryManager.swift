//
//  CategoryManager.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import Foundation

protocol CategoriesManagerDelegate{
    func updateCategoryStatsLabels()
}

class CategoriesManager {
    var categories: CategoryData = CategoryData(trivia_categories: [QuizApp.Category(id: 0, name: "All Categories")])
    var categoryStats: CategoryStats?
    
    var delegate: CategoriesManagerDelegate?
    
    func getCategories() {
        if let url = URL(string: "https://opentdb.com/api_category.php") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            var results = try decoder.decode(CategoryData.self, from: safeData)
                            
                            // Prepend an option for all categories
                            results.trivia_categories.insert(QuizApp.Category(id: 0, name: "All Categories"), at: 0)
                            self.categories = results
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getCategoriesStats(catId: Int){
        if let url = URL(string: "https://opentdb.com/api_count.php?category=\(catId)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(CategoryStats.self, from: safeData)
                            print(results)
                            self.categoryStats = results
                            self.delegate?.updateCategoryStatsLabels()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

