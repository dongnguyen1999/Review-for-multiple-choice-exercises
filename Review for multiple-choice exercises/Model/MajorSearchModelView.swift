//
//  MajorSearchModelView.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/21/21.
//

import Foundation
class MajorSearchModelView {
    
    var majormodeldelegate: MajorModelDeledate!
    

    init(majormodeldelegate: MajorModelDeledate) {
        self.majormodeldelegate   = majormodeldelegate
    }
    
    func ListMajor(facultyId : Int) {
        DownloadAsyncTask.GET(url: "\(Constants.URL.URL_SEVER)api/major.php?type=list&facultyId=\(facultyId)", showDialog: true) { (errorCode, msg, arrayData) in
            print (errorCode)
            //chuyen trang
            if errorCode == 0 {
       
                self.majormodeldelegate.onSuccessMajor(listMajor: [MajorModel].deserialize(from: arrayData) as? [MajorModel])
            }
             else {
              
                self.majormodeldelegate.onErrorMajor(message: msg)
             }
        }
    }
    
}
