//
//  MenuController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/19/21.
//

import UIKit

class MenuController: UIViewController {

    override func viewDidLoad() {
          super.viewDidLoad()
          getdata()
          // Do any additional setup after loading the view.
      }
    //Anh xa
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBAction func EditProfile(_ sender: UITapGestureRecognizer) {
        print("EditProfile")
    }
    @IBAction func HistorySearch(_ sender: UITapGestureRecognizer) {
        print("HistorySearch")
    }
    @IBAction func ImportantTest(_ sender: Any) {
        print("ImportantTest")
           }
    // Get du lieu
    
    @IBAction func BtnLogout(_ sender: UIButton) {
        print("Đăng xuất")
    }
    func getdata() {
        nameLabel.text = "Nhuận"
        phoneLabel.text = "0333 000 999"
        
    }
  
    
   


}
