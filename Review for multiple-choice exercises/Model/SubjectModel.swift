//
//  SubjectModel.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 20/01/2021.
//

import Foundation
import HandyJSON

class SubjectModel: HandyJSON {
    
    var subjectId: Int = 0
    var majorId: Int = 0
    var subjectName: String = ""
    
    required init(){}
}

