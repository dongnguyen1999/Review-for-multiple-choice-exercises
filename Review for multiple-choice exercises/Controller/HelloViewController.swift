//
//  HelloViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 23/01/2021.
//

import UIKit

class HelloViewController: UIViewController {
    
//    @IBOutlet weak var helloText: UILabel!
    
    @IBOutlet weak var squareView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        helloText.text = "World"
        squareView.backgroundColor = .red
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        squareView.layer.cornerRadius = squareView.frame.width / 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
