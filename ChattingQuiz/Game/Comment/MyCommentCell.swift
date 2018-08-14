//
//  MyCommentCell.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 8. 14..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit

class MyCommentCell: CommentCell {
	
	
	@IBOutlet weak var backgroundImgView: UIImageView!
	@IBOutlet weak var messageLabel: UILabel!
	
	override func didSetComment() {
		super.didSetComment()
		
		self.messageLabel.text = comment?.message
		messageLabel.bringSubview(toFront: backgroundImgView)
	}
}
