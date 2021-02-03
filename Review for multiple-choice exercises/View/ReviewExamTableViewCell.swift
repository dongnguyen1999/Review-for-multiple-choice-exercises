//
//  ReviewExamTableViewCell.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 03/02/2021.
//

import UIKit

class ReviewExamTableViewCell: UITableViewCell {
    
    var question: QuestionModel!
    var questionIndex: Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var aAnswerView: UIView!
    @IBOutlet weak var bAnswerView: UIView!
    @IBOutlet weak var cAnswerView: UIView!
    @IBOutlet weak var dAnswerView: UIView!
    
    
    @IBOutlet weak var aAnswerLabel: UILabel!
    @IBOutlet weak var bAnswerLabel: UILabel!
    @IBOutlet weak var cAnswerLabel: UILabel!
    @IBOutlet weak var dAnswerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setQuestion(index: Int, question: QuestionModel) {
        self.question = question
        self.questionIndex = index
        loadQuestion()
    }
    
    func loadQuestion() {
        questionLabel.text = "\(questionIndex+1). \(question.questionName)"
        aAnswerLabel.text = question.answer1
        bAnswerLabel.text = question.answer2
        cAnswerLabel.text = question.answer3
        dAnswerLabel.text = question.answer4
        
        let views = [aAnswerView, bAnswerView, cAnswerView, dAnswerView]
        for view in views {
            view!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2))
        }
        if let answer = question.answerTask {
            if answer == question.answer {
                views[answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#6FCF97"))
            }
            else {
                views[answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#F89500"))
                views[question.answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#FF6D6D"))
            }
        } else {
            views[question.answer-1]!.roundWithBorder(borderRadius: 5, borderWidth: 1, borderColor: UIColor(hex: "#FF6D6D"))
        }
        
        
    }

}
