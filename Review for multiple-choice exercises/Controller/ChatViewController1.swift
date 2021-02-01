//
//  ChatViewController1.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/29/21.
//

import UIKit
import HandyJSON
struct ChatMessage {
    let userId :Int
    let message: String
    let isIncoming : Bool
    
}
class ChatModel: HandyJSON  {
    var recipientId: Int = 0
    var response: String = ""
    required init(){}
}

class ChatViewController1: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    fileprivate let cellId = "sendercell"
    var chatMessages = [ChatMessage]()
    @IBOutlet weak var txtfieldmesseage: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableview.separatorStyle = .none
        tableview.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self.actionButton), for: .touchUpInside)
        button.setImage(UIImage(named: "icn_send"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(txtfieldmesseage.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        let btnicon = UIButton(type: .custom)
        btnicon.setImage(UIImage(named: "icn_icon"), for: .normal)
        btnicon.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        btnicon.frame = CGRect(x: CGFloat(txtfieldmesseage.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        txtfieldmesseage.leftView = btnicon
        txtfieldmesseage.leftViewMode = .always
        txtfieldmesseage.rightView = button
        txtfieldmesseage.rightViewMode = .always
        txtfieldmesseage.layer.borderWidth = 1
        txtfieldmesseage.layer.cornerRadius = 15
        txtfieldmesseage.resignFirstResponder()
        tableview?.contentMode = UIView.ContentMode.scaleToFill
        tableview.layer.contents = UIImage(named:"background_history")?.cgImage
        tableview.layer.cornerRadius = 15
        //keyboard
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @IBAction func actionButton(_ sender: Any) {
        let txtmesseage = txtfieldmesseage.text ?? ""
        let userId = 1
        
        self.chatMessages.append(ChatMessage(userId: userId, message: txtmesseage, isIncoming: false))
        
        let body:[String: Any?] = ["message" : txtmesseage, "userId" : userId]
        print("body \(body)")
        DownloadAsyncTask.POST(url:Constants.URL.URL_SEVER+"api/chatbot.php" , body: body as [String : Any], showDialog: true) { (errorCode, msg, data) in
            if errorCode == 0 {
                
                if let chatModel = ChatModel.deserialize(from: data) as? ChatModel {
                    self.chatMessages.append(ChatMessage(userId: 1 , message: chatModel.response, isIncoming: true))
                    self.tableview.reloadData()
                }
                
            }else{
                
            }
            
        }
    
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func Keyboard(notification : Notification)  {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame,from : view.window)
        if notification.name == UIResponder.keyboardWillHideNotification{
            scrollView.contentInset = UIEdgeInsets.zero
        }else{
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! ChatMessageCell
        
        let chatMessage = chatMessages[indexPath.row]
        cell.messageLabel.text = chatMessage.message
        
        cell.chatMessage = chatMessage
        return cell
    
        
    }
    
    
}
