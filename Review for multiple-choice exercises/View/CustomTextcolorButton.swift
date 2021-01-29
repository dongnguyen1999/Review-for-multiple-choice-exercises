//
//  CustomTextcolorButton.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/28/21.
//

import UIKit
class CustomTextcolorButton: UIButton {

    required init?(coder aDecoder:NSCoder) {
        super.init(coder:  aDecoder)
        self.stylettextcolorbutton()
        
    }
    private func stylettextcolorbutton(){

        self.setTitleColor(UIColor(red: 1, green: 0.404, blue: 0.106, alpha: 1), for: .normal)
      
        
    }
}
