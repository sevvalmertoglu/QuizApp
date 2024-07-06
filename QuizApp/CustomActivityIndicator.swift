//
//  CustomActivityIndicator.swift
//  QuizApp
//
//  Created by Şevval Mertoğlu on 6.07.2024.
//

import UIKit
import Lottie

class CustomActivityIndicator: UIView {
    
    private var animationView: LottieAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimation()
    }
    
    private func setupAnimation() {
        animationView = LottieAnimationView(name: "Animation - 1720274300680")
        animationView?.frame = self.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1.0
        
        if let animationView = animationView {
            self.addSubview(animationView)
        }
    }
    
    func startAnimating() {
        self.isHidden = false
        animationView?.play()
    }
    
    func stopAnimating() {
        animationView?.stop()
        self.isHidden = true
    }
}

