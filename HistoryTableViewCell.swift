//
//  HistoryTableViewCell.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 20/01/2021.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var scoreContainerView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var facultyNameLabel: UILabel!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var createDateLabel: UILabel!
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 10
            frame.origin.x += 24
            frame.size.height -= 15
            frame.size.width -= 2 * 24
            super.frame = frame
        }
    }
    
    var color = UIColor.black
    
    
//    override func prepareForReuse() {
////        self.scoreContainerView.layer.cornerRadius = self.scoreContainerView.frame.height / 2
////        self.scoreContainerView.roundWithBorder(borderWidth: 3, borderColor: UIColor.black)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.scoreContainerView.roundWithBorder(borderWidth: 3, borderColor: UIColor.black)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
        self.scoreContainerView.roundWithBorder(borderWidth: 3, borderColor: color)
        self.contentView.backgroundColor = .white;
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.shadowOffset = CGSize(width: 1, height: 0);
        self.contentView.layer.shadowColor = UIColor.black.cgColor;
        self.contentView.layer.shadowRadius = 5;
        self.contentView.layer.shadowOpacity = 0.25;
    }
    
    

}
