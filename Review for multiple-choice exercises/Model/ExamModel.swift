//
//  ExamModel.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 19/01/2021.
//

import Foundation
import HandyJSON

class ExamModel: HandyJSON {
    
    var examId: Int = 0
    var userId: Int = 0
    var subjectId: Int = 0
    var createDate: String = ""
    var closeDate: String = ""
    var nbQuestion: Int = 0
    var duration: Int = 0
    var isImportant: Int = 0
    var score: Float?
    
    var facultyName: String = ""
    var subjectName: String = ""
    
    
    required init(){}
}

