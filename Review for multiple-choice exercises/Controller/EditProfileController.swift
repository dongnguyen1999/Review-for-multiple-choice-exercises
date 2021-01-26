//
//  EditProfileController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import UIKit
import Alamofire
class EditProfileController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var Btneditprofile: UIButton!
    
    var userModel: UserModel!
    
    @IBAction func onCancelEdit(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //Chọn ảnh
    @IBAction func BtnChoosefile(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate =  self
        vc.allowsEditing = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        Btneditprofile.layer.cornerRadius = 15
        Btneditprofile.layer.shadowOpacity = 0.5
        Btneditprofile.layer.shadowOffset = CGSize(width: 0, height: 0)
        Btneditprofile.layer.backgroundColor = UIColor(red: 1, green: 0.404, blue: 0.106, alpha: 1).cgColor
        //tắt keyboard
        self.hideKeyboardWhenTappedAround()
        getdata()

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
                 dismiss(animated: true, completion: nil)
             }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])  {

              
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("Expected: \(info)")
               }
                avatar.image = selectedImage
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
        userModel = PreferencesUtils.getCachedUserModel()
        
        name.text = userModel.name
        phone.text = userModel.phone
        email.text = userModel.email
        
    }
    
    // Chinh sửa thông tin người dùng
    @IBAction func actionButton(_ sender: Any) {
        let nameedit = name.text ?? ""
        let emailedit = email.text ?? ""
        let phoneedit = phone.text ??  ""
        let userId = 1
//        let imagedata = avatar.image?.pngData()
        let imagedata = avatar.image?.jpegData(compressionQuality: 0.3)
        let img = imagedata?.base64EncodedString()
        /*
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageData = image.jpegData(compressionQuality: 1)!
        let encodedImage = imageData.base64EncodedString()
        */
        let body:[String: Any?] = ["type" : "edit", "userId" : userId, "name" : nameedit, "phone" : phoneedit, "email" : emailedit, "avatar" : img]
               print("body \(body)")
               DownloadAsyncTask.POST(url:Constants.URL.URL_SEVER+"api/user.php" , body: body as [String : Any], showDialog: true) { (errorCode, msg, data) in
                   if errorCode == 0 {
                    self.ThongBao(title: "Thông Báo", message: "\(msg)")
                    
                   }else{
                    self.ThongBao(title: "Thông Báo", message: "\(msg)")
                   }
               }
 
        
    }
    //Button trở lại trang trước
    @IBAction func ButtonBack(_ sender: UIButton) {
       // self.navigationController!.popToRootViewController(animated: true)
    }
    
 
}
