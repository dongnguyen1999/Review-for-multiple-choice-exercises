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
       
        self.contentView.backgroundColor = .white;
        self.layer.cornerRadius = 15;
        self.layer.shadowOffset = CGSize(width: 1, height: 0);
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowRadius = 15;
        self.layer.shadowOpacity = 3;
        
        
        }
    override open var frame: CGRect {
            get {
                return super.frame
            }
            set (newFrame) {
                var frame =  newFrame
                frame.origin.y += 10
                frame.origin.x += 20
                frame.size.height -= 15
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
