//
//  ViewController.swift
//  KeyboardAutoScrollView
//
//  Created by vorrawut on 11/8/2562 BE.
//  Copyright © 2562 Vorrawut Judasri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // View to focus when show keyboard
    private var activeField: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tapper = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        // use UIKeyboardFrameEndUserInfoKey to fix iOS11 keyboard height
        var keyboardSize = keyboardInfo.cgRectValue.size
        
        // Add safeAreaInsets.bottom offset for iPhoneX
        if #available(iOS 11.0, *) {
            keyboardSize.height += view.safeAreaInsets.bottom
        }
        
        // Add bottom content inset [clear when hide keyboard event fired (keyboardWillHide:)]
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = view.frame
        aRect.size.height -= keyboardSize.height
        
        if let activeField = activeField {
            //convert frame into scrollView coordinate
            let convertedFrame = activeField.convert(activeField.bounds, to: scrollView)
            if !aRect.contains(convertedFrame.origin) {
                scrollView.scrollRectToVisible(convertedFrame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // Reset bottom content inset
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

