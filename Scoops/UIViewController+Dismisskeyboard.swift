//
//  UIViewController+Dismisskeyboard.swift
//  Scoops
//
//  Created by David Cava Jimenez on 9/4/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
