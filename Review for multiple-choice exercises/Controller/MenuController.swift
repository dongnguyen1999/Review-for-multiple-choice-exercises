//
//  MenuController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/19/21.
//

import UIKit

class MenuController: UIViewController {
    
    
    var userModel: UserModel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var importantTestView: customViewMenuProfile!
    @IBOutlet weak var historySearchView: customViewMenuProfile!
    @IBOutlet weak var editprofileView: customViewMenuProfile!
    @IBOutlet weak var avatarMenu: customAvatar!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light 
        getdata()
        // Do any additional setup after loading the view.
        editprofileView.setOnTapListener(context: self, action: #selector(onEditProfile(sender:)))
        historySearchView.setOnTapListener(context: self, action: #selector(onHistorySearch(sender:)))
        importantTestView.setOnTapListener(context: self, action: #selector(onImportantTest(sender:)))
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getdata()
    }
    
    @objc func onEditProfile(sender: UIGestureRecognizer){
        performSegue(withIdentifier: "editprofile", sender: self)
    }
    @objc func onHistorySearch(sender: UIGestureRecognizer){
        performSegue(withIdentifier: "showhistorysearch", sender: self)
    }
    @objc func onImportantTest(sender: UIGestureRecognizer){
        performSegue(withIdentifier: "showimportanttest", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? HistoryViewController {
            switch segue.identifier {
            case "showhistorysearch":
                dest.historyType = HistoryViewType.ALL_HISTORY
            case "showimportanttest":
                dest.historyType = HistoryViewType.IMPORTANT_HISTORY
            default:
                break
            }
        }
    }
    
    
    @IBAction func BtnLogout(_ sender: UIButton) {
        Prefs.removeCachedUserModel()
        changeRootViewToLogin()
    }
 
    func getdata() {
        userModel = Prefs.getCachedUserModel()
        nameLabel.text = userModel?.name
        phoneLabel.text = userModel?.phone
        guard let url = URL(string: "\(Constants.URL.URL_SEVER)\(self.userModel.avatar)") else { return }
        if userModel.avatar == "" {
             avatarMenu.image = UIImage(named: "avatar")
        } else {
            guard let url = URL(string: "\(Constants.URL.URL_SEVER)\(self.userModel.avatar)") else { return }
            if let data = try? Data(contentsOf: url) {
                 // Create Image and Update Image View
                 let image = UIImage(data: data)
                avatarMenu.image = image
            }
        }
    }
    
    func changeRootViewToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        UIApplication.shared.windows.first?.rootViewController = loginViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    }
}
