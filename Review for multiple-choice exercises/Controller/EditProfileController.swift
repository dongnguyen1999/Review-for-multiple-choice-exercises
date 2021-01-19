//
//  EditProfileController.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/18/21.
//

import UIKit

class EditProfileController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var Btneditprofile: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Btneditprofile.layer.cornerRadius = 15
        Btneditprofile.layer.shadowOpacity = 0.5
        Btneditprofile.layer.shadowOffset = CGSize(width: 0, height: 0)
        Btneditprofile.layer.backgroundColor = UIColor(red: 1, green: 0.404, blue: 0.106, alpha: 1).cgColor
    
    


       
    }
    



}
