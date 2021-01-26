//
//  QuestionModel.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 25/01/2021.
//

import Foundation
import HandyJSON

class QuestionModel: HandyJSON {
    
    var questionId: Int = 0
    var subjectId: Int = 0
    var questionName: String = ""
    var answer1: String = ""
    var answer2: String = ""
    var answer3: String = ""
    var answer4: String = ""
    var answer: Int = 0
    var answerTask: Int?
    
    required init() {}
    
}
