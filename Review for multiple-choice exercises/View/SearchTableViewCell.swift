//
//  SearchTableViewCell.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/24/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = 15
            
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
            self.layer.masksToBounds = false
            self.layer.borderWidth = 0.1
            self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            self.layer.shadowOffset = CGSize(width: 0.5, height: 1)
            self.layer.shadowOpacity = 3
            self.layer.shadowPath = shadowPath.cgPath
  
        }
    override open var frame: CGRect {
            get {
                return super.frame
            }
            set (newFrame) {
                var frame =  newFrame
                frame.origin.y += 10
                frame.origin.x += 20
                frame.size.height -= 5
                frame.size.width -= 2 * 24
                
                super.frame = frame
            }
        }
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
