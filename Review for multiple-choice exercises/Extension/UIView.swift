//
//  UIView.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 18/01/2021.
//

import Foundation
import UIKit

public extension UIView {
    
    func roundWithBorder(borderRadius radius: CGFloat = -1, borderWidth width: CGFloat = 0, borderColor color: UIColor = .black) {
        self.clipsToBounds = true
        if radius != -1 {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.size.width/2
        }
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func boxShadow(color: UIColor = .black, offsetX: CGFloat, offsetY: CGFloat, opacity: Float, radius: CGFloat) {
        roundWithBorder(borderRadius: radius)
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    func setOnTapListener(context: UIView, action selector: Selector? ) {
        let singleTap = UITapGestureRecognizer(target: context, action: selector)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }
    
}
