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
    //Ánh xạ
    fileprivate let cellId = "sendercell"
    var chatMessages = [ChatMessage]()
    
    
    @IBOutlet weak var txtfieldmesseage: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var tapkeyboard: UITapGestureRecognizer!
    @IBOutlet weak var viewscroll: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Design tableview
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableview.separatorStyle = .none
        tableview.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableview?.contentMode = UIView.ContentMode.scaleToFill
        tableview.layer.contents = UIImage(named:"background_history")?.cgImage
        tableview.layer.cornerRadius = 15
        
        //Thêm icon vào textfield
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(self.actionButton(_:)), for: .touchUpInside)
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
        overrideUserInterfaceStyle = .light
        //keyboard scrollview
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    //onclick textfield
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //keyboard scrollview
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            tableview.contentInset = .zero
        } else {
            
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - (view.safeAreaInsets.bottom - 10), right: 0)
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                tableview.contentInset = UIEdgeInsets(top: keyboardSize.height - 90, left: 0, bottom: 0, right: 0)
                
                
            }
            
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        
    }
    //Tắt navigation Bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func actionTapKeyboard(_ sender: Any) {
        self.view.endEditing(true)
        self.scrollView.contentSize=CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 300)
    }
    
    //Bắt sự kiện click gửi tin nhắn
    @IBAction func actionButton(_ sender: Any) {
        
        let txtmesseage = txtfieldmesseage.text ?? ""
        if txtmesseage == "" {
            return
        }
        
        let userId = 1
        
        self.chatMessages.append(ChatMessage(userId: userId, message: txtmesseage, isIncoming: false))
        
        let body:[String: Any?] = ["message" : txtmesseage, "userId" : userId]
        print("body \(body)")
        DownloadAsyncTask.POST(url:Constants.URL.URL_SEVER+"api/chatbot.php" , body: body as [String : Any], showDialog: true) { (errorCode, msg, data) in
            if errorCode == 0 {
                if let chatModel = ChatModel.deserialize(from: data) as? ChatModel {
                    self.chatMessages.append(ChatMessage(userId: 1 , message: chatModel.response, isIncoming: true))
                    self.tableview.reloadData()
                    
                    let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
                    
                    self.tableview.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                    self.txtfieldmesseage.text = ""
                }
            }else{
                print(msg)
            }
            
        }
        
    }
    
    
    
    //Set data vào table
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
