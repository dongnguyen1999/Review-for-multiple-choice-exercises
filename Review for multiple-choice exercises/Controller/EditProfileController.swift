//
//  EditProfileController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import UIKit
import Alamofire
class EditProfileController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Anh xa
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var btneditprofile: UIButton!
    var userModel: UserModel!
    @IBOutlet weak var btnback: UIBarButtonItem!
    @IBOutlet weak var btnedit: UIBarButtonItem!
    @IBOutlet weak var imageview: UIView!
 
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //Giao dien
        btneditprofile.layer.cornerRadius = 15
        btneditprofile.layer.shadowOpacity = 0.5
        btneditprofile.layer.shadowOffset = CGSize(width: 0, height: 0)
        btneditprofile.layer.backgroundColor = UIColor(red: 1, green: 0.404, blue: 0.106, alpha: 1).cgColor
        backgroundview?.contentMode = UIView.ContentMode.scaleToFill
        backgroundview.layer.contents = UIImage(named:"background_history")?.cgImage
        imageview.layer.cornerRadius =  imageview.frame.height/2
        imageview.layer.shadowColor = UIColor.darkGray.cgColor
        imageview.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        imageview.layer.shadowRadius = 25.0
        imageview.layer.shadowOpacity = 0.9
        avatar.layer.cornerRadius =  imageview.frame.height/2
        avatar.clipsToBounds = true
     
        //tắt keyboard
        self.hideKeyboardWhenTappedAround()
        getdata()
        
    }
    
    @IBAction func chooseEdit(_ sender: Any) {
        name.isUserInteractionEnabled = true
        phone.isUserInteractionEnabled = true
        email.isUserInteractionEnabled = false
       
        
    }
    
    @IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate =  self
        vc.allowsEditing = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
        avatar.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func ThongBao( title : String, message : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default, handler:nil )
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
        return
        
    }
    func getdata()  {
        userModel = Prefs.getCachedUserModel()
        name.text = userModel.name
        phone.text = userModel.phone
        email.text = userModel.email
        guard let url = URL(string: "\(Constants.URL.URL_SEVER)\(self.userModel.avatar)") else { return }
        if let data = try? Data(contentsOf: url) {
             // Create Image and Update Image View
             avatar.image = UIImage(data: data)
         }
        //Enabled textfiled
        name.isUserInteractionEnabled = false
        phone.isUserInteractionEnabled = false
        email.isUserInteractionEnabled = false
        
    }
    
    // Chinh sửa thông tin người dùng
    @IBAction func actionEdit(_ sender: UIButton) {
        name.isUserInteractionEnabled = false
        phone.isUserInteractionEnabled = false
        email.isUserInteractionEnabled = false
        let nameedit = name.text ?? ""
        let emailedit = email.text ?? ""
        let phoneedit = phone.text ??  ""
        let userId = userModel.userId
        let imageData: Data = avatar.image!.jpegData(compressionQuality: 0.5)!
        let imageStr: String = imageData.base64EncodedString()
        
        let body:[String: Any?] = ["type" : "edit", "userId" : userId, "name" : nameedit, "phone" : phoneedit, "avatar" : imageStr]
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
