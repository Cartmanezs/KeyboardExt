//
//  KeyboardViewController.swift
//  Mykeyboard
//
//  Created by Ingvar on 7/11/19.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit
import Foundation

class KeyboardViewController: UIInputViewController {
    //MARK: IBOutlet
    @IBOutlet weak var row1: UIStackView!
    @IBOutlet weak var row2: UIStackView!
    @IBOutlet weak var row3: UIStackView!
    @IBOutlet weak var row4: UIStackView!
    @IBOutlet weak var numberSet: UIStackView!
    @IBOutlet weak var charSet: UIStackView!
    @IBOutlet weak var shiftButton: UIButton!
   
    var shiftStatus: Int! // 0 - off, 1 - on, 2 - CAPS
    private var proxy: UITextDocumentProxy! {
        return textDocumentProxy
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charSet.isHidden = true
        shiftStatus = 1
    }
    
    
    @IBAction func nextKeyboardPressed(_ sender: UIButton) {
        advanceToNextInputMode()
    }
    
    @IBAction func charSetPressed(_ sender: UIButton) {
        if sender.titleLabel!.text == "!@#" {
            charSet.isHidden = false
            numberSet.isHidden = true
            sender.setTitle("123", for: UIControl.State.normal)
        } else {
            charSet.isHidden = true
            numberSet.isHidden = false
            sender.setTitle("!@#", for: UIControl.State.normal)
        }
    }
    
    @IBAction func shiftPressed(_ sender: UIButton) {
        shiftStatus = shiftStatus > 0 ? 0 : 1
        shiftChange(containerView: row1)
        shiftChange(containerView: row2)
        shiftChange(containerView: row3 )
    }
    
    @IBAction func keyPressed(sender: UIButton) {
        let string = sender.titleLabel!.text
        
        proxy.insertText("\(string!)")
        
        if shiftStatus == 1 {
            shiftPressed(self.shiftButton)
        }
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            sender.transform = CGAffineTransform(translationX: 2.0, y: 2.0) //CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2,0)
        }) { (_) -> Void in
                sender.transform = CGAffineTransform(translationX: 1.0, y: 1.0) // CGAffineTransform(CGAffineTransformIdentity, 1.0, 1.0)
        }
    }
    
    @IBAction func backSpacePressed(_ sender: UIButton) {
        proxy.deleteBackward()
    }
    
    
    @IBAction func returnPressed(_ sender: UIButton) {
        proxy.insertText("\n")
    }
    
    @IBAction func spacePressed(_ sender: UIButton) {
        proxy.insertText(" ")
    }
    
    @IBAction func shiftDoubleTapped(_ sender: UITapGestureRecognizer) {
        shiftStatus = 2
        shiftChange(containerView: row1)
        shiftChange(containerView: row2)
        shiftChange(containerView: row3)
    }
    
    @IBAction func shiftTrippleTapped(_ sender: UITapGestureRecognizer) {
        shiftStatus = 0
        shiftPressed(self.shiftButton)
    }
    
    func shiftChange(containerView: UIStackView ) {
        
        for view in containerView.subviews {
            if let button = view as? UIButton {
                let buttonTitle = button.titleLabel!.text
                if shiftStatus == 0 {
                    let text = buttonTitle!.lowercased()
                    button.setTitle("\(text)", for: .normal)
                } else {
                    let text = buttonTitle!.uppercased()
                    button.setTitle("\(text)", for: .normal)
                }
            }
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}
