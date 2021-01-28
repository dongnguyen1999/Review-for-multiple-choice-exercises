//
//  RegisterController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/15/21.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var BtnRegister: UIButton!
    @IBOutlet weak var AvatarRegister: UIImageView!
    @IBOutlet weak var PhoneRegister: UITextField!
    @IBOutlet weak var PasswordRegister: UITextField!
    @IBOutlet weak var EmailRegister: UITextField!
    @IBOutlet weak var nameRegister: UITextField!
    //Khai bao bien view
    /*
    @IBOutlet weak var BtnRegister: UIButton!
    @IBOutlet weak var nameRegister: UITextField!
    @IBOutlet weak var EmailRegister: UITextField!
    @IBOutlet weak var PasswordRegister: UITextField!
    @IBOutlet weak var PhoneRegister: UITextField!
    @IBOutlet weak var AvatarRegister: UIImageView!
    
    */
    var img = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BtnRegister.layer.cornerRadius = 20
        BtnRegister.layer.shadowOpacity = 0.5
        BtnRegister.layer.shadowOffset = CGSize(width: 0, height: 0)
        BtnRegister.layer.backgroundColor = UIColor(red: 1, green: 0.404, blue: 0.106, alpha: 1).cgColor
        //custom avatar
        AvatarRegister.layer.borderWidth = 1.0
        AvatarRegister.layer.masksToBounds = false
        AvatarRegister.layer.cornerRadius = AvatarRegister.frame.height/2
        AvatarRegister.clipsToBounds = true
        // ẩn bản phím
        self.hideKeyboardWhenTappedAround()
   
    }
    
    func ThongBao( title : String, message : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "OK", style: .default, handler:nil )
                    alertController.addAction(actionOk)
                    self.present(alertController, animated: true, completion: nil)
                    return
        
    }
  

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
                 dismiss(animated: true, completion: nil)
             }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

              
               guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                  fatalError("Expected: \(info)")
              }
              
            
        AvatarRegister.image = selectedImage
      
        
        
      let imagedata:NSData = (selectedImage.pngData()!) as NSData
           img = imagedata.base64EncodedString()
       
        
          
            
              dismiss(animated: true, completion: nil)
          }
    
   
    

    
    @IBAction func SelectImage(_ sender: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate =  self
        vc.allowsEditing = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    @IBAction func actionRegister(_ sender: UIButton) {
        let name = nameRegister.text ?? ""
        let email = EmailRegister.text ?? ""
        let password = PasswordRegister.text ?? ""
        let phone = PhoneRegister.text ??  ""
    
        let fullBase64String = "data:image/png;base64,\(img))"

    
       
        
        if name ==  "" || email == "" || password == "" || phone == "" {
            ThongBao(title: "Thông Báo", message: "Vui lòng nhập đầy đủ thông tin")
        } else if (phone.count < 10 || phone.count > 10){
               ThongBao(title: "Thông Báo", message: "Bạn nhập sai số điện thoại")
                
        }else if (password.count < 6){
            ThongBao(title: "Thông Báo", message: "Mật khẩu quá ngắn")
        }
            else {
                
                let body:[String: Any?] = ["type" : "register", "email" : email, "name" : name, "phone" : phone, "password" : password, "avatar" : fullBase64String]
                       print("body \(body)")

                       DownloadAsyncTask.POST(url:Constants.URL.URL_SEVER+"api/user.php" , body: body as [String : Any], showDialog: true) { (errorCode, msg, data) in
                           if errorCode == 0 {
                            self.ThongBao(title: "Thông Báo", message: "\(msg)")
                            
                           }else{
                            self.ThongBao(title: "Thông Báo", message: "\(msg)")
                           }

                       }
  
   
                }

        

    }
   
    
    
  

}

