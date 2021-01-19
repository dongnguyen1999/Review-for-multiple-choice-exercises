//
//  DebugLog.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/14/21.
//

import Foundation
struct DebugLog {
    public static func printLog(msg: String){
        if Constants.IS_DEBUG {
            print(msg)
        }
    }
}
