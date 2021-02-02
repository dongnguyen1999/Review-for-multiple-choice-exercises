//
//  ViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 1/13/21.
//

import UIKit




class ViewController: UIViewController, UserModelView, UITextFieldDelegate{
    
    var loginviewmodel : LoginViewModel!
    // Dong wrote
    
    
    @IBOutlet weak var btnshowregister: CustomTextcolorButton!
    @IBOutlet weak var UsernameLogin: UITextField!
    @IBOutlet weak var BtnLogin: UIButton!
    @IBOutlet weak var PasswordLogin: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    var emailchecked = 0
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        BtnLogin.layer.cornerRadius = 20
        BtnLogin.layer.shadowOpacity = 0.5
        BtnLogin.layer.backgroundColor = UIColor(red: 1, green: 0.404, blue: 0.106, alpha: 1).cgColor
        overrideUserInterfaceStyle = .light 
        //Ẩn bàn phím
        self.hideKeyboardWhenTappedAround()
        //scrollview theo bàn phím
     
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //Check user login status
        if Prefs.getCachedUserModel() != nil {
            changeRootViewToHome()
        }
        
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
    
    func onSuccess(listAccount: [UserModel]?) {
        if let userModel = listAccount?[0] {
            Prefs.cacheUserModel(model: userModel)
            changeRootViewToHome()
        } else {
            ThongBao(title: "Thong Bao", message: "Lỗi đăng nhập, vui lòng thử lại")
        }
    }
    
    func onError(msg: String) {
        ThongBao(title: "Thong Bao", message: msg)
    }
    
    func ThongBao( title : String, message : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default, handler:nil )
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
        return
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
    @IBAction func actionLogin(_ sender: Any) {
        let username = UsernameLogin.text ?? ""
        let password = PasswordLogin.text ?? ""
        //check email đúng sai
        if isValidEmail(testStr: username) {
            emailchecked = 0
        }else{
            emailchecked = 1
        }
        // ràng buộc đăng nhập
        if username == "" && password == ""{
            ThongBao(title: "Thông Báo", message: "Vui lòng nhập đẩy đủ thông tin")
        }else if (username == ""){
            ThongBao(title: "Thông Báo", message: "Bạn chưa nhập email")
        }else if (password == ""){
            ThongBao(title: "Thông Báo", message: "Bạn chưa nhập mật khẩu")
        }else if (emailchecked == 1){
            ThongBao(title: "Thông Báo", message: "Bạn nhập sai email")
        }
        else {
            loginviewmodel=LoginViewModel(usermodelView: self)
            loginviewmodel.onLogin(username: username, password: password)
        }
    }
    
    func changeRootViewToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigation") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = homeViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
