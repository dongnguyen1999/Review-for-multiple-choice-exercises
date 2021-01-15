//
//  ResponseModel.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/14/21.
//

import Foundation
struct ResponseModel<T : Codable>: Codable  {
    let errorCode : String
    let message: String
    let data: T
}
