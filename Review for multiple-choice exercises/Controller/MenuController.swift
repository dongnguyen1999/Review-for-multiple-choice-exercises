//
//  MenuController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/19/21.
//

import UIKit

class MenuController: UIViewController {
    
    var userModel: UserModel!
    @IBOutlet weak var backButton: UIImageView!
    
    override func viewDidLoad() {
          super.viewDidLoad()
          getdata()
          // Do any additional setup after loading the view.
        backButton.setOnTapListener(context: self, action: #selector(onBackButtonClicked(sender:)))
      }
    //Anh xa
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBAction func EditProfile(_ sender: UITapGestureRecognizer) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let editProfileViewController = mainStoryboard.instantiateViewController(withIdentifier: "EditProfileScreen") as? EditProfileController else {
            print("Can not create edit profile screen view controller")
            return
        }
        
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    @IBAction func HistorySearch(_ sender: UITapGestureRecognizer) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let historyViewController = mainStoryboard.instantiateViewController(withIdentifier: "HistoryScreen") as? HistoryViewController else {
            print("Can not create history screen view controller")
            return
        }
        
        navigationController?.pushViewController(historyViewController, animated: true)
    }
    @IBAction func ImportantTest(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let historyViewController = mainStoryboard.instantiateViewController(withIdentifier: "HistoryScreen") as? HistoryViewController else {
            print("Can not create history screen view controller")
            return
        }
        
        navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    @objc func onBackButtonClicked(sender: UIGestureRecognizer){
        navigationController?.popViewController(animated: true)
    }
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
