//
//  AnswerCollectionViewCell.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 27/01/2021.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!

    
    var enableColor = false {
        didSet {
            updateRow()
        }
    }
    
    var index = 0
    
    var questionsInRow: [QuestionModel]! {
        didSet {
            updateRow()
        }
    }
    
    var onTappedAnswerCell: ((Int) -> Void)? {
        didSet {
            for cell in stackView.arrangedSubviews {
                if let cell = cell as? AnswerCell {
                    cell.onTappedAnswerCelL = onTappedAnswerCell
                }
            }
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 10
            frame.origin.x += 24
            frame.size.height -= 10
            frame.size.width -= 2 * 24
            super.frame = frame
        }
    }
    
    func updateRow() {
        stackView.subviews.forEach({ $0.removeFromSuperview() })
        for i in 0..<questionsInRow.count {
            let question = questionsInRow[i]
            let cell = AnswerCell(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            cell.numberQuestion = index * questionsInRow.count + i + 1
            cell.answer = question.answerTask
            
            if enableColor == true {
                if question.answer == question.answerTask {
                    cell.color = UIColor(hex: "#62B18C")
                } else {
                    cell.color = UIColor(hex: "#FF6D6D")
                }
            }
            
            stackView.addArrangedSubview(cell)
        }
    }
    
    
}
