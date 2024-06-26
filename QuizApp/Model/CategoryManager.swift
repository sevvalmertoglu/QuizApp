//
//  CategoryManager.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 14.06.2024.
//

import Foundation

/// Protocol to be implemented by delegates of CategoriesManager to update category statistics labels.
protocol CategoriesManagerDelegate{
    func updateCategoryStatsLabels()
}

/// Manages fetching and storing trivia categories and their statistics.
class CategoriesManager {
    var categories: CategoryData = CategoryData(trivia_categories: [QuizApp.Category(id: 0, name: "All Categories")])
    var categoryStats: CategoryStats?
    
    var delegate: CategoriesManagerDelegate?
    
    /// Fetches trivia categories from the Open Trivia Database API.
    ///
    /// This function makes a network request to retrieve the available trivia categories.
    /// Upon successful retrieval, it updates the `categories` property with the fetched data.
    /// An "All Categories" option is prepended to the list of categories.
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
    
    /// Fetches statistics for a specific trivia category from the Open Trivia Database API.
    ///
    /// This function makes a network request to retrieve the statistics for a given category ID.
    /// Upon successful retrieval, it updates the `categoryStats` property with the fetched data and notifies the delegate to update the UI labels.
    ///
    /// - Parameter catId: The ID of the category for which to fetch statistics.
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

