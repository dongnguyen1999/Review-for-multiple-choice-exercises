//
//  CustomLabelEditProfile.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import UIKit

class CustomLabelEditProfile: UILabel {

    required init?(coder aDecoder:NSCoder) {
        super.init(coder:  aDecoder)
        self.styleLabelView()
        
    }
    private func styleLabelView(){
    
        self.font = UIFont(name: "OpenSans-Bold", size: 16)
      
        self.layer.masksToBounds = true
        
        
    }}
