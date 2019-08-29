//
//  ChatInputBar.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 23..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit

class ChatInputBar: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	@IBOutlet weak var messageTextField: UITextField!
	@IBOutlet weak var sendButton: UIButton!
	
	static func initFromNib() -> ChatInputBar {
		return Bundle.main.loadNibNamed("ChatInputBar", owner: self, options: nil)?.first as! ChatInputBar
	}
}
