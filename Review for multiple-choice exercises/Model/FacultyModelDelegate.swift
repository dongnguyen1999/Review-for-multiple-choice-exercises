//
//  FacultyModelDelegate.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/20/21.
//

import Foundation
protocol FacultyModelDelegate {
    func onSuccess(listFaculty: [FacultyModel]?)
    func onError(msg: String)
}
