//
//  ChatModelDelegate.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 2/1/21.
//

import Foundation
protocol ChatModelDelegate {
    func onSuccess(listchat: [ChatModel]?)
    func onError(message: String)
}
