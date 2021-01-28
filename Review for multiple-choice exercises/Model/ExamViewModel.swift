//
//  ExamViewModel.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 25/01/2021.
//

import Foundation

class ExamViewModel {
    
    var examDelegate: ExamModelDelegate!
    
    init(examDelegate: ExamModelDelegate) {
        self.examDelegate = examDelegate
    }
    
    func startExam(userId: Int, subjectId: Int) {
        let body:[String: Any?] = ["type" : RequestType.OPEN_NEW, "userId" : userId, "subjectId": subjectId]
        DownloadAsyncTask.POST(url: "\(Constants.URL.URL_SEVER)api/exam.php", body: body as [String : Any], showDialog: true) { (errorCode, msg, arrayData) in
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
    
    func cancelTemporatyExam(examId: Int ) {
        let body:[String: Any?] = ["type" : RequestType.CANCEL, "examId" : examId]
        DownloadAsyncTask.POST(url: "\(Constants.URL.URL_SEVER)api/exam.php", body: body as [String : Any], showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
                self.examDelegate.onDeleteSuccess(message: msg)
            }
             else {
                self.examDelegate.onError(message: msg)
             }
        }
    }
    
}
