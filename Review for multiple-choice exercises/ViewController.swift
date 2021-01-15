//
//  ViewController.swift
//  Review for multiple-choice exercises
//
//  Created by Dong Nguyen on 1/13/21.
//

import UIKit


class ViewController: UIViewController {

    
    // Dong wrote
    @IBOutlet weak var UsernameLogin: UITextField!
    @IBOutlet weak var BtnLogin: UIButton!
    
    @IBOutlet weak var PasswordLogin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        BtnLogin.layer.cornerRadius = 20
        BtnLogin.layer.shadowOpacity = 0.5
        BtnLogin.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    @IBAction func actionLogin(_ sender: Any) {
        let username = UsernameLogin.text ?? ""
        let password = PasswordLogin.text ?? ""
        if username == "" || password == ""{
            let alertController = UIAlertController(title: "Thông Báo", message: "Vui lòng nhập đẩy đủ thông tin", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "OK", style: .default, handler:nil )
            alertController.addAction(actionOk)
            self.present(alertController, animated: true, completion: nil)
               return
            

            
        }else {
            
            guard let url = URL(string: "\(ServerConstant.server)/api/login.php?type=login&email=\(username)&password=\(password)") else {
                fatalError("Url is nil")
            }

            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
          

            let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {
                    // Kiem tra loi mang
                    print("error", error ?? "Unknown error")
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // //check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
          

                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
            }

            task.resume()
        }
    }
    
 
    
        
    }


