//
//  CustomTextField.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/13/21.
//

import UIKit

class CustomTextField: UITextField {
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:  aDecoder)
        styleTextField()
        
    }
    private func styleTextField(){
       let boder = CALayer()
        let width = CGFloat(0.5)
        
        boder.borderColor = UIColor.gray.cgColor
        boder.borderWidth = width
        boder.frame = CGRect(x: 0, y: bounds.size.height - width, width: bounds.size.width, height: bounds.size.height)
        
        self.layer.addSublayer(boder)
        self.layer.masksToBounds = true
        
        
    }
}
