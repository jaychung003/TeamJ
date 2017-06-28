//
//  ThirdVC.swift
//  TinderSwipe
//
//  Created by Jay Chung on 6/15/17.
//  Copyright © 2017 cssummer17. All rights reserved.
//

import UIKit

extension SwipeVC {
    func hideButtons() {
        button1.alpha = 0
        button2.alpha = 0
        button3.alpha = 0
        button4.alpha = 0
    }
    func toggleMenu() {
        if darkFillView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 0.5, animations: {
                self.darkFillView.transform = CGAffineTransform(scaleX: 11, y: 11)
                self.menuView.transform = CGAffineTransform(translationX: 0, y: -67)
                self.menuButton.transform = CGAffineTransform(rotationAngle: 3.141592)
            }) { (true) in
                self.toggleSharedButtons()
            }
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.darkFillView.transform = .identity
                self.menuView.transform = .identity
                self.menuButton.transform = .identity
                self.toggleSharedButtons()
            }) 
        }
    }
    
    func toggleSharedButtons() {
        let alpha = CGFloat(button1.alpha == 0 ? 1 : 0)
        button1.alpha = alpha
        button2.alpha = alpha
        button3.alpha = alpha
        button4.alpha = alpha
    }
}
