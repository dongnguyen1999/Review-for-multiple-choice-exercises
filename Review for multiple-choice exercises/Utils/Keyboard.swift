//
//  Keyboard.swift
//  Review for multiple-choice exercises
//
//  Created by TranNhuan on 1/19/21.
//

import Foundation
import UIKit
 
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
 
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
