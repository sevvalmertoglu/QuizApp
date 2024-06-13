//
//  ViewController.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 11.06.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func loginButton(_ sender: Any) {
        performSegue(withIdentifier: "toLoginVC", sender: nil)
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        performSegue(withIdentifier: "toRegisterVC", sender: nil)
    }
    
}

