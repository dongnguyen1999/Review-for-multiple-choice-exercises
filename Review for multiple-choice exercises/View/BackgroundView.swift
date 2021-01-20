//
//  BackgroundView.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import UIKit

class BackgroundView: UIView {

    required init?(coder aDecoder:NSCoder) {
        super.init(coder:  aDecoder)
        self.styleMenuProfile()
        
    }
    private func styleMenuProfile(){

      
        self.layer.backgroundColor = UIColor(red: 0.961, green: 0.973, blue: 0.992, alpha: 1).cgColor
    }
}
