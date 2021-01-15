//
//  UserModel.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/14/21.
//

import Foundation

struct UserModel : Codable {
    let userID : Int
    let email : String
    let password : String
    let avatar : String
    let phone : String
}


