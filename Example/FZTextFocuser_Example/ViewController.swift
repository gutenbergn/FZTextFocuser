//
//  ViewController.swift
//  FZTextFocuser_Example
//
//  Created by Gutenberg Neto on 31/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import FZTextFocuser

class ViewController: UIViewController {
    @IBOutlet private weak var textFocuser1: FZTextFocuser!
    @IBOutlet private weak var textFocuser2: FZTextFocuser!
    @IBOutlet private weak var textTappedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTextFocusers()
    }
    
    private func setupTextFocusers() {
        let font = UIFont.systemFont(ofSize: 50)
        
        self.textFocuser1.delegate = self
        self.textFocuser1.attributedText = NSAttributedString(string: "THIS IS A STRING WHICH WILL BE ENTIRELY HIGHLIGHTED WHEN FOCUSED", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black])
        self.textFocuser1.focusedBackgroundColor = .red
        
        self.textFocuser2.delegate = self
        self.textFocuser2.attributedText = NSAttributedString(string: "ONLY THIS PORTION OF THIS STRING WILL BE HIGHLIGHTED WHEN FOCUSED", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black])
        self.textFocuser2.addFocusableText("THIS PORTION", backgroundColor: .blue, cornerRadius: 20)
    }
}

extension ViewController: FZTextFocuserDelegate {
    func fzTextFocuserDidTapView(textFocuser: FZTextFocuser) {
        if textFocuser == self.textFocuser1 {
            self.textTappedLabel.text = "THE FIRST TEXT WAS TAPPED"
        } else if textFocuser == self.textFocuser2 {
            self.textTappedLabel.text = "THE SECOND TEXT WAS TAPPED"
        }
    }
}

