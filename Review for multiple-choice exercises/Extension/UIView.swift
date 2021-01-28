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
        
    func boxShadow(color: UIColor = .black, offsetX: CGFloat, offsetY: CGFloat, blur: CGFloat = 3, opacity: Float, radius: CGFloat, scale: Bool = true) {
        roundWithBorder(borderRadius: radius)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowRadius = blur
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func setOnTapListener(context: UIView, action selector: Selector? ) {
        let singleTap = UITapGestureRecognizer(target: context, action: selector)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }
    
    func setOnTapListener(context: UIViewController, action selector: Selector? ) {
        let singleTap = UITapGestureRecognizer(target: context, action: selector)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }
}
