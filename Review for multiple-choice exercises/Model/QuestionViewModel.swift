//
//  QuestionViewModel.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 25/01/2021.
//

import Foundation
class QuestionViewModel {
    
    var questionDelegate: QuestionModelDelegate!
    
    init(questionDelegate: QuestionModelDelegate) {
        self.questionDelegate = questionDelegate
    }
    
    func onGetListQuestion(examId: Int) {
        DownloadAsyncTask.GET(url: "\(Constants.URL.URL_SEVER)api/question.php?type=\(RequestType.LIST)&examId=\(examId)", showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
                self.questionDelegate.onSuccess(listQuestion: [QuestionModel].deserialize(from: arrayData) as? [QuestionModel])
            }
             else {
                self.questionDelegate.onError(message: msg)
             }
        }
    }
    
    func answerQuestion(examId: Int, questionId: Int, answer: Int?) {
        var body:[String: Any?] = ["type" : "answerQuestion", "examId" : examId, "questionId": questionId]
        if answer != nil {
            body["answerTask"] = answer!
        }
        DownloadAsyncTask.POST(url: "\(Constants.URL.URL_SEVER)api/exam.php?type=\(RequestType.OPEN_NEW)", body: body as [String : Any], showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
                self.questionDelegate.onSuccess(message: msg)
            }
             else {
                self.questionDelegate.onError(message: msg)
             }
        }
    }
    
}
