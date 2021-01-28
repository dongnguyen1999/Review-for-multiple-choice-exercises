//
//  File.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 25/01/2021.
//

import Foundation
protocol QuestionModelDelegate {
    func onSuccess(listQuestion: [QuestionModel]?)
    func onSuccess(message: String)
    func onError(message: String)
}
