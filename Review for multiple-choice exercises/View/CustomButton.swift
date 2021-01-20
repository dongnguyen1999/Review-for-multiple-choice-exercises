//
//  CustomButton.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import UIKit

class CustomButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.styleButton()
        
    }
    private func styleButton() {
        self.layer.backgroundColor = UIColor(red: 1, green: 0.404, blue: 0.106, alpha: 1).cgColor
        self.layer.cornerRadius = 15
    }
}
