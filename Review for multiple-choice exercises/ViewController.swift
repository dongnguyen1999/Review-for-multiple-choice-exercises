//
//  ViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 1/13/21.
//

import UIKit


class ViewController: UIViewController, UserModelView{
    
    

    var loginviewmodel : LoginViewModel!
    // Dong wrote
    @IBOutlet weak var UsernameLogin: UITextField!
    @IBOutlet weak var BtnLogin: UIButton!
    @IBOutlet weak var PasswordLogin: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //model = UserModel()
        // Do any additional setup after loading the view.
        BtnLogin.layer.cornerRadius = 20
        BtnLogin.layer.shadowOpacity = 0.5
        BtnLogin.layer.backgroundColor = UIColor(red: 1, green: 0.404, blue: 0.106, alpha: 1).cgColor
        
        //Check user login status
        if PreferencesUtils.getCachedUserModel() != nil {
            changeRootViewToHome()
        }
        
    }
    
    func onSuccess(listAccount: [UserModel]?) {
        if let userModel = listAccount?[0] {
            PreferencesUtils.cacheUserModel(model: userModel)
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
    
    
    @IBAction func actionLogin(_ sender: Any) {
        let username = UsernameLogin.text ?? ""
        let password = PasswordLogin.text ?? ""
        if username == "" || password == ""{
           ThongBao(title: "Thông Báp", message: "Vui lòng nhập đẩy đủ thông tin")

            
        }else {
            loginviewmodel = LoginViewModel(usermodelView: self)
            loginviewmodel.onLogin(username: username, password: password)
        }
    }
    
    func changeRootViewToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as! HomeViewController
        UIApplication.shared.windows.first?.rootViewController = homeViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}
