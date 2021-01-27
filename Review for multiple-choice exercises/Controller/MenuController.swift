//
//  MenuController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/19/21.
//

import UIKit

class MenuController: UIViewController {
    
    var userModel: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
        // Do any additional setup after loading the view.
    }
    
    //Anh xa
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    // Get du lieu
    
    @IBAction func BtnLogout(_ sender: UIButton) {
        Prefs.removeCachedUserModel()
        changeRootViewToLogin()
    }
    func getdata() {
        userModel = Prefs.getCachedUserModel()
        nameLabel.text = userModel?.name
        phoneLabel.text = userModel?.phone
    }
  
    func changeRootViewToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        UIApplication.shared.windows.first?.rootViewController = loginViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
   


}
