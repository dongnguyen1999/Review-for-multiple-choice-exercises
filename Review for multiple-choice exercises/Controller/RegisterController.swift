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
    var emailchecked = 0
    
    @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light 
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
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    //keyboard scrollview
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollview.contentInset = .zero
        } else {
            scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - (view.safeAreaInsets.bottom - 10), right: 0)
        }
        
        scrollview.scrollIndicatorInsets = scrollview.contentInset
        
        
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
        AvatarRegister.image = chosenImage
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
    //Ràng buộc email
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
   //End ràng buộc email
    @IBAction func actionRegister(_ sender: UIButton) {
        let name = nameRegister.text ?? ""
        let email = EmailRegister.text ?? ""
        let password = PasswordRegister.text ?? ""
        let phone = PhoneRegister.text ??  ""
        let imageData: Data = AvatarRegister.image!.jpegData(compressionQuality: 0.5)!
        let imageStr: String = imageData.base64EncodedString()
        //check email đúng sai
        if isValidEmail(testStr: email) {
            emailchecked = 0
        }else{
            emailchecked = 1
        }
        //Ràng buộc các form trong đăng kí
        if name ==  "" || email == "" || password == "" || phone == "" {
            ThongBao(title: "Thông Báo", message: "Vui lòng nhập đầy đủ thông tin")
        } else if (phone.count < 10 || phone.count > 10){
            ThongBao(title: "Thông Báo", message: "Bạn nhập sai số điện thoại")
            
        }else if (password.count < 6){
            ThongBao(title: "Thông Báo", message: "Mật khẩu quá ngắn")
        }else if(emailchecked == 1){
            ThongBao(title: "Thông Báo", message: "Bạn nhập sai địa chỉ email")
        }
        else {
            let body:[String: Any?] = ["type" : "register", "email" : email, "name" : name, "phone" : phone, "password" : password, "avatar" : imageStr]
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
