//
//  DownloadAsyncTask.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/14/21.
//

import Foundation
import UIKit
import HandyJSON
import SwiftOverlays

class DownloadAsyncTask {
    
    public static func GET(url: String, showDialog: Bool, downloadCalback: @escaping (_ errorCode: Int, _ message: String, _ data: String?) -> Void){
        if Utils.isConnectedToNetwork() == false {/*Rớt mạng*/
            DispatchQueue.main.async {
                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry, no Internet connectivity detected. Please reconnect and try again.", nil)
            }
            SwiftOverlays.removeAllBlockingOverlays()
        }else{
            let session = URLSession.shared
            var token: String = "bearer "
            /*  if let tokenModel = Prefs.shared.getToken() {
             token = token + "\(tokenModel.access_token)"
             }*/
            let headers = [
                "content-type": "application/json",
                "authorization": token,
                "cache-control": "no-cache",
                "postman-token": "f05da2d1-ffe9-895f-baf0-8dfb3a5b0fcb"
            ]
            if url.isEmpty { /*Truyền tham số sai*/
                DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+":Đường dẫn (URL) truyền vào rỗng.")
                SwiftOverlays.removeAllBlockingOverlays()
                return
            }
              let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            if showDialog {
                //SwiftOverlays.showBlockingWaitOverlayWithText(LocalizationHelper.shared.localized("Loading...")!)
                SwiftOverlays.showBlockingWaitOverlayWithText("Loading...")
            }
            DebugLog.printLog(msg: "URL_REQUEST: "+url)
            
            let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                DispatchQueue.main.async {
                    SwiftOverlays.removeAllBlockingOverlays()
                }
                if error != nil {/*Lỗi trong quá trình tải*/
                    DebugLog.printLog(msg: "DOWNLOAD_ERROR: Lỗi trong quá trình tải, tên lỗi: "+error!.localizedDescription)
                    DispatchQueue.main.async {
                        downloadCalback(Constants.ERROR_CODE_ERROR, error!.localizedDescription, nil)
                    }
                }else{
                    /*Dữ liệu trả về rỗng*/
                    guard let data = data else{
                        DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Dữ liệu trả về rỗng.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                        return
                    }
                    
                    do{
                        let jsonEncode = String(data: data, encoding: .utf8)
                        let dataEncode = jsonEncode?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        DebugLog.printLog(msg: Constants.DOWNLOAD_RESPONSE+": "+jsonEncode!)
                        
                        if dataEncode == nil || jsonEncode == nil{/*Lỗi trong quá trình encode*/
                            DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Lỗi trong quá trình encode.")
                            DispatchQueue.main.async {
                                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                            }
                        }else{
                            let json = try? JSONSerialization.jsonObject(with: dataEncode!, options: []) as! [String: AnyObject]
                            
                            guard let errorCode = json?["errorCode"] as? Int else {
                                DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có errorCode.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            guard let message = json?["message"] as? String else {
                                DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có message.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            
                            guard let data = json?["data"] else {/*Data trả về nil*/
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            if Utils.nullToNil(value: data) == nil {/*"data" trả về là null*/
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            DispatchQueue.main.async {
                                downloadCalback(errorCode, message, Utils.hashMapToJson(any: data))
                            }
                        }
                    } catch{
                        DebugLog.printLog(msg: "Dữ liệu trả về không đúng định dạng Json.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                    }
                    
                }
            }
            task.resume()
            
        }
    }
    public static func getPostString(params:[String:Any?]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value!)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    public static func POST(url: String, body: [String: Any], showDialog: Bool, downloadCalback: @escaping (_ errorCode: Int, _ message: String, _ data: String?) -> Void){
        if Utils.isConnectedToNetwork() == false {/*Rớt mạng*/
            DispatchQueue.main.async {
                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry, no Internet connectivity detected. Please reconnect and try again.", nil)
            }
            SwiftOverlays.removeAllBlockingOverlays()
        }else{
            let session = URLSession.shared
            var token: String = "bearer "
            /*
             if let tokenModel = Prefs.shared.getToken() {
             token = token + "\(tokenModel.access_token)"
             }*/
            let headers = [
                "content-type": "application/x-www-form-urlencoded",
                "authorization": token,
                "cache-control": "no-cache",
                "postman-token": "f05da2d1-ffe9-895f-baf0-8dfb3a5b0fcb"
            ]
            if url.isEmpty { /*Truyền tham số sai*/
                DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+":Đường dẫn (URL) truyền vào rỗng.")
                SwiftOverlays.removeAllBlockingOverlays()
                return
            }
            
            //            let postData = try? JSONSerialization.data(withJSONObject: body, options: [])
            
            
        
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            
            let postString = self.getPostString(params: body)
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            
            if showDialog {
                SwiftOverlays.showBlockingWaitOverlayWithText("Loading...")
                // SwiftOverlays.showBlockingWaitOverlayWithText(LocalizationHelper.shared.localized("Loading...")!)
            }
            DebugLog.printLog(msg: "URL_REQUEST: "+url)
            
            let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                DispatchQueue.main.async {
                    SwiftOverlays.removeAllBlockingOverlays()
                }
                if error != nil {/*Lỗi trong quá trình tải*/
                    DebugLog.printLog(msg: "DOWNLOAD_ERROR: Lỗi trong quá trình tải, tên lỗi: "+error!.localizedDescription)
                    DispatchQueue.main.async {
                        downloadCalback(Constants.ERROR_CODE_ERROR, error!.localizedDescription, nil)
                    }
                }else{
                    /*Dữ liệu trả về rỗng*/
                    guard let data = data else{
                        DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Dữ liệu trả về rỗng.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                        return
                    }
                    
                    do{
                        let jsonEncode = String(data: data, encoding: .utf8)
                        let dataEncode = jsonEncode?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        DebugLog.printLog(msg: Constants.DOWNLOAD_RESPONSE+": "+jsonEncode!)
                        
                        if dataEncode == nil || jsonEncode == nil{/*Lỗi trong quá trình encode*/
                            DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Lỗi trong quá trình encode.")
                            DispatchQueue.main.async {
                                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                            }
                        }else{
                            let json = try? JSONSerialization.jsonObject(with: dataEncode!, options: []) as! [String: AnyObject]
                            print("\(json)")
                            guard let errorCode = json?["errorCode"] as? Int else {
                                DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có errorCode.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            guard let message = json?["message"] as? String else {
                                DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có message.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            guard let data = json?["data"] else {/*Chuỗi json trả về không có data */
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            if Utils.nullToNil(value: data) == nil {/*"data" trả về là null*/
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            DispatchQueue.main.async {
                                downloadCalback(errorCode, message, Utils.hashMapToJson(any: data))
                            }
                        }
                    } catch{
                        DebugLog.printLog(msg: "Dữ liệu trả về không đúng định dạng Json.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                    }
                    
                }
            }
            task.resume()
            
        }
    }
    
}
