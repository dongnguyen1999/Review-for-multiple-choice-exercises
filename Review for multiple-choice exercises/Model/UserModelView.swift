//
//  UserModelView.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import Foundation
protocol UserModelView {
    func onSuccess(listAccount: [UserModel]?)
    func onError(msg: String)
}
