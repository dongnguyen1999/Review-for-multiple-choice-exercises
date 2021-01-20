//
//  ExamModelDelegate.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 19/01/2021.
//

import Foundation

protocol ExamModelDelegate {
    func onSuccess(listExam: [ExamModel]?)
    func onError(message: String)
}

