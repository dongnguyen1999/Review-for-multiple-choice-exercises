//
//  SubjectModelDelegate.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 20/01/2021.
//

import Foundation
protocol SubjectModelDelegate {
    func onSuccess(listSubject: [SubjectModel]?)
    func onError(message: String)
}

