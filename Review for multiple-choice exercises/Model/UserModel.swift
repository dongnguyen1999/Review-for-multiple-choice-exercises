//
//  UserModel.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/14/21.
//


import Foundation
import HandyJSON

class UserModel: HandyJSON {
    
    var userId: Int = 0
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var avatar: String = ""
    var phone: String = ""
  
    required init(){}
}
