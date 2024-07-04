//
//  UserIconViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 2.07.2024.
//

import UIKit
import FirebaseAuth

class UserIconViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var userIconCollectionView: UICollectionView!
    
    
    // Sections and their items
    let sections = [
        ("Animals", (1...6).map { "animal\($0)" }),
        ("Men", (1...6).map { "man\($0)" }),
        ("Women", (1...6).map { "woman\($0)" })
    ]
    
    // Property to keep track of the selected index
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIconCollectionView.dataSource = self
        userIconCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 30) // Header size
        userIconCollectionView.collectionViewLayout = layout
        
        // Register header view
        userIconCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserIconCollectionViewCell", for: indexPath) as! UserIconCollectionViewCell
        let iconName = sections[indexPath.section].1[indexPath.item]
        cell.imageView.image = UIImage(named: iconName)
        
        cell.checkImageView.isHidden = indexPath != selectedIndex
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = selectedIndex {
            selectedIndex = indexPath
            collectionView.reloadItems(at: [previousIndex, indexPath])
        } else {
            selectedIndex = indexPath
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let selectedIndex = selectedIndex else {
            let alert = UIAlertController(title: "Warning", message: "Please select an icon.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let iconName = sections[selectedIndex.section].1[selectedIndex.item]
        saveSelectedIcon(iconName)
    }
    
    private func saveSelectedIcon(_ iconName: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.shared.saveUserIcon(userId: userId, iconName: iconName) { result in
            switch result {
            case .success():
                let alert = UIAlertController(title: "Successful", message: "Profile icon saved.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            case .failure(let error):
                let alert = UIAlertController(title: "ERROR", message: "Error saving profile icon: \(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Implement header view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
            headerView.backgroundColor = .systemIndigo
            
            for subview in headerView.subviews {
                subview.removeFromSuperview()
            }
            
            let label = UILabel(frame: headerView.bounds)
            label.text = sections[indexPath.section].0
            label.textAlignment = .center
            label.textColor = .white
            headerView.addSubview(label)
            
            return headerView
        }
        return UICollectionReusableView()
    }
}
