//
//  CustomButtonSearch.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/21/21.
//

import UIKit

class CustomButtonSearch: UISegmentedControl {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.styleButton()
        
    }
    private func styleButton() {
        self.layer.backgroundColor = UIColor(red: 0.565, green: 0.412, blue: 0.804, alpha: 1).cgColor
       
    }

}
