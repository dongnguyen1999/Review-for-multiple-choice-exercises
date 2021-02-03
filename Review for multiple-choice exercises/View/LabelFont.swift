//
//  LabelFont.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 2/2/21.
//

import UIKit

class LabelFont: UILabel {

    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:  aDecoder)
        
        self.stylefont()
        
    }
    private func stylefont(){
        self.font = UIFont(name: "OpenSans-Regular ", size: 17)
            
    }
        
}
