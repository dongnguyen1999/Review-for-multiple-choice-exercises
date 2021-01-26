//
//  SubjectSearchModelDelegate.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/24/21.
//

import Foundation
protocol SubjectSearchModelDelegate {
    func onSuccessSubject(listSubject: [SubjectModel]?)
    func onErrorSubject(message: String)
}
