//
//  LoginViewModel.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import Foundation
class LoginViewModel {
    
    var usermodelView: UserModelView!
    
    init(usermodelView: UserModelView) {
        self.usermodelView   = usermodelView
    }
func onLogin( username: String,  password: String) {
        
    DownloadAsyncTask.GET(url: "\(Constants.URL.URL_SEVER)api/login.php?type=login&email=\(username)&password=\(password)", showDialog: true) { (errorCode, msg, arrayData) in
        print (errorCode)
        //chuyen trang
        if errorCode == 0 {
            self.usermodelView.onSuccess(listAccount: [UserModel].deserialize(from: arrayData) as? [UserModel])
        }
         else {
          
            self.usermodelView.onError(msg: msg)
            
            
    }

    
}
    }
}
