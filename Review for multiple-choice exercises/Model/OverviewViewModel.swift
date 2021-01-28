//
//  OverviewModel.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 28/01/2021.
//

import Foundation

class OverviewViewModel {
    
    var examDelegate: ExamModelDelegate!
    
    init(examDelegate: ExamModelDelegate) {
        self.examDelegate = examDelegate
    }
    
    func submit(examId: Int) {
        let body:[String: Any?] = ["type" : RequestType.SUBMIT, "examId" : examId]
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
    
    func markImportant(examId: Int, isImportant: Bool) {
        var importantFlag = 0
        if isImportant == true {
            importantFlag = 1
        }
        let body:[String: Any?] = ["type" : RequestType.MARK_IMPORTANT, "examId" : examId, "isImportant": importantFlag]
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
    
    
    
}
