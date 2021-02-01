//
//  ChatMessageCell.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/29/21.
//

import UIKit

class ChatMessageCell: UITableViewCell {

    let messageLabel = UILabel()
    let bubblebackgroundView = UIView()
    var leadingConstraint : NSLayoutConstraint!
    var trailingConstraint : NSLayoutConstraint!
    var chatMessage: ChatMessage!{
        didSet{
            bubblebackgroundView.backgroundColor = chatMessage.isIncoming ? .white : UIColor(hex: "FFFB9D")
            messageLabel.textColor = chatMessage.isIncoming ? .black : UIColor(hex: "364A2B")
            messageLabel.text = chatMessage.message
            if chatMessage.isIncoming{
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }else{
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        bubblebackgroundView.backgroundColor = .red
        bubblebackgroundView.layer.cornerRadius = 16
        bubblebackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubblebackgroundView)
    
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        let constraints = [messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                           
                           messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                           //messageLabel.widthAnchor.constraint(equalToConstant: 250),
                           messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
                           bubblebackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor,constant: -16),
                           bubblebackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor,constant: -16),
                           bubblebackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor,constant: 16),
                           bubblebackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor,constant: 16),
                           
        ]
        NSLayoutConstraint.activate(constraints)
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -32)
        trailingConstraint.isActive = true
        
    }
   
    required init?(coder: NSCoder) {
        fatalError("Error")
    }

}
