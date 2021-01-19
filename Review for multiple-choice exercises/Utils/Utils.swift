//
//  Utils.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/14/21.
//

import Foundation
import  UIKit
import  CommonCrypto
import  SystemConfiguration
// check Connections
class Utils {
    
    /* */
    // Check Connections
    public static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // Check internet connection
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //Chuyển kiểu hashmap sang chuỗi json
       public static func hashMapToJson(any: Any) -> String{
           
           if let theJSONData = try? JSONSerialization.data(
               withJSONObject: any,
               options: []) {
               guard let json = String(data: theJSONData, encoding: .utf8)else{
                   return ""
               }
               return json
               
           }
           return ""
       }
    
    //Chuyển chuỗi null sang nil
    public static func nullToNil(value: AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        }else {
            return value
        }
    }
    
    /* */
    // Background corner view
    static public var backgroundColor: UIColor{
        return #colorLiteral(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    }
    
    //String to hex md5
       static func hexMD5(string: String) -> String {
        
           let messageData = string.data(using:.utf8)!
           var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
           
           _ = digestData.withUnsafeMutableBytes {digestBytes in
               messageData.withUnsafeBytes {messageBytes in
                   CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
               }
           }
           let hexMd5 = digestData.map { String(format: "%02hhx", $0) }.joined()
           return hexMd5
       }
       
       //String to encrypt sha1
       static func encyptSha1(string: String) -> String {
           
           let data = string.data(using: String.Encoding.utf8)!
           var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
           data.withUnsafeBytes {
               _ = CC_SHA1($0, CC_LONG(data.count), &digest)
           }
           return Data(bytes: digest).base64EncodedString()
           
       }
       
       //Password encrypt
       static func passwordEncrypt (password: String) -> String {
           let hash = encyptSha1(string: hexMD5(string: password)).data(using: .utf8)
           let pass = hash?.base64EncodedString()
           return pass!
       }
    
    /* */
    // Add image to UITextField
    public static func addImage(name:String, y: Int, width: Int, height: Int, textfield:UITextField){
        let imageView = UIImageView();
        let image = UIImage(named: name);
        let leftImageView = UIImageView()
        leftImageView.image = image
        let leftView = UIView()
        let view = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRect(x: 0, y: 0, width: 55, height: 20)
        leftImageView.frame = CGRect(x: 24, y: y, width: width, height: height)
        view.addSubview(imageView)
        textfield.leftView = leftView;
        textfield.leftViewMode = UITextField.ViewMode.always
    }
    
    static public func setFontForTitle(_ vc: UIViewController){
        vc.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1370447576, green: 0.2209252417, blue: 0.3009321094, alpha: 1), NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 19)!]
        vc.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

