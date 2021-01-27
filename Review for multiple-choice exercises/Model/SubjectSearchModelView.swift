//
//  SubjectSearchModelView.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/24/21.
//

import Foundation
class SubjectSearchModelView {
    
    var subjectmodeldelegate: SubjectSearchModelDelegate!
    

    init(subjectmodeldelegate: SubjectSearchModelDelegate) {
        self.subjectmodeldelegate   = subjectmodeldelegate
    }
    
    func ListSubject(majorId : Int) {
        DownloadAsyncTask.GET(url: "\(Constants.URL.URL_SEVER)api/subject.php?type=list&majorId=\(majorId)", showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
       
                self.subjectmodeldelegate.onSuccessSubject(listSubject: [SubjectModel].deserialize(from: arrayData) as? [SubjectModel])
            }
             else {
              
                self.subjectmodeldelegate.onErrorSubject(message: msg)
             }
        }
    }
    func ListSubjectSearch() {
        DownloadAsyncTask.GET(url: "\(Constants.URL.URL_SEVER)api/subject.php?type=list", showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
       
                self.subjectmodeldelegate.onSuccessSubject(listSubject: [SubjectModel].deserialize(from: arrayData) as? [SubjectModel])
            }
             else {
              
                self.subjectmodeldelegate.onErrorSubject(message: msg)
             }
        }
    }
}
