//
//  customAvatar.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import UIKit

class customAvatar: UIImageView {

    required init?(coder aDecoder:NSCoder) {
        super.init(coder:  aDecoder)
        self.styleAvatar()
        
    }
    private func styleAvatar(){

        //custom avatar
          self.layer.borderWidth = 1.0
          self.layer.masksToBounds = false
          self.layer.cornerRadius = self.frame.height/2
          self.clipsToBounds = true

        
    }
  

}
