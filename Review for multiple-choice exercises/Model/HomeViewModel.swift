//
//  HomeViewModel.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 19/01/2021.
//

import Foundation
class HomeViewModel {
    
    var examDelegate: ExamModelDelegate!
    var subjectDelegate: SubjectModelDelegate!
    
    init(examDelegate: ExamModelDelegate, subjectDelegate: SubjectModelDelegate ) {
        self.examDelegate = examDelegate
        self.subjectDelegate = subjectDelegate
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
    
    func onGetSubjectDetails(listSubjectId: [Int]) {
        var requestString = ""
        for subjectId in listSubjectId {
            requestString += "&subjectIds[]=\(subjectId)"
        }
        DownloadAsyncTask.GET(url: "\(Constants.URL.URL_SEVER)api/subject.php?type=\(RequestType.LIST)\(requestString)", showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
                self.subjectDelegate.onSuccess(listSubject: [SubjectModel].deserialize(from: arrayData) as? [SubjectModel])
            }
             else {
                self.subjectDelegate.onError(message: msg)
             }
        }
    }
    
}
