//
//  HistoryViewModel.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 21/01/2021.
//

import Foundation
class HistoryViewModel {
    
    var examDelegate: ExamModelDelegate!
    
    init(examDelegate: ExamModelDelegate) {
        self.examDelegate = examDelegate
    }
    
    func onGetListExam(userId: Int) {
        DownloadAsyncTask.GET(url: "\(Constants.URL.URL_SEVER)api/exam.php?type=\(RequestType.LIST)&userId=\(userId)", showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
                self.examDelegate.onSuccess(listExam: [ExamModel].deserialize(from: arrayData) as? [ExamModel])
            }
             else {
                self.examDelegate.onError(message: msg)
             }
        }
    }
    
}
