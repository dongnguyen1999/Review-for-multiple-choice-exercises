//
//  customViewMenuProfile.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import UIKit

class customViewMenuProfile: UIView {

    required init?(coder aDecoder:NSCoder) {
        super.init(coder:  aDecoder)
        self.styleMenuProfile()
        
    }
    private func styleMenuProfile(){

        self.layer.cornerRadius = 15
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)

    }

}
