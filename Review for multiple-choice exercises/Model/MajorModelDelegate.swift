//
//  MajorModelDelegate.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/21/21.
//

import Foundation
protocol MajorModelDeledate {
    func onSuccessMajor(listMajor: [MajorModel]?)
    func onErrorMajor(message: String)
}
