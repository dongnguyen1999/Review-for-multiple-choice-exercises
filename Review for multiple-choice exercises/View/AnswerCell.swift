//
//  AnswerCell.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 27/01/2021.
//

import UIKit

class AnswerCell: UIView {
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    let answerLetters = ["_", "A", "B", "C", "D"]
    var color = UIColor(hex: "#9C60D3") {
        didSet {
            questionNumberLabel.textColor = color
            answerLabel.textColor = color
        }
    }
    var numberQuestion: Int = 0 {
        didSet {
            questionNumberLabel.text = "\(numberQuestion)"
        }
    }
    var answer: Int? {
        didSet {
            if answer != nil {
                answerLabel.text = "\(answerLetters[answer!])"
            } else {
                answerLabel.isHidden = true
            }
        }
    }
    
    @objc var onTappedAnswerCelL: ((Int) -> Void)? {
        didSet {
            self.setOnTapListener(context: self, action: #selector(callbackQuestionNumber(sender:)))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadLayout()
    }
    
    func loadLayout() {
        let viewFromXib = Bundle.main.loadNibNamed("AnswerCell", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/1.0).isActive = true
        
    }
    
    @objc func callbackQuestionNumber(sender: UITapGestureRecognizer) {
        if let callback = onTappedAnswerCelL {
            callback(numberQuestion)
        }
        
    }

}
