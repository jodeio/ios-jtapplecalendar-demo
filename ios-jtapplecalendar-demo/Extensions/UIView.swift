//
//  UIView.swift
//  ios-jtapplecalendar-demo
//
//  Created by Joshua de Guzman on 06/06/2018.
//  Copyright © 2018 xrojan. All rights reserved.
//

import UIKit

extension UIView{
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
