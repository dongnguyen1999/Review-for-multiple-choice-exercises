//
//  FacultySearchModelView.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/20/21.
//

import Foundation
class FacultySearchModelView {
    
    var facultydelegate: FacultyModelDelegate!
    
    init(facultydelegate: FacultyModelDelegate) {
        self.facultydelegate   = facultydelegate
    }

    
    func ListFaculty() {
        DownloadAsyncTask.GET(url: "\(Constants.URL.URL_SEVER)api/faculty.php?type=list", showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
                
                self.facultydelegate.onSuccess(listFaculty: [FacultyModel].deserialize(from: arrayData) as? [FacultyModel])
            }
             else {
              
                self.facultydelegate.onError(message: msg)
             }
        }
    }
    
}
