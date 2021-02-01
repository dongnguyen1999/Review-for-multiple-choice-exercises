//
//  ChatModel.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 2/1/21.
//

import Foundation

import HandyJSON
class ChatModel: HandyJSON  {
    var recipientId: Int = 0
    var response: String = ""
    
    required init(){}
}
