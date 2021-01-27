//
//  FacultyModelDelegate.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 21/01/2021.
//

import Foundation

protocol FacultyModelDelegate {
    func onSuccess(listFaculty: [FacultyModel]?)
    func onError(message: String)
}
