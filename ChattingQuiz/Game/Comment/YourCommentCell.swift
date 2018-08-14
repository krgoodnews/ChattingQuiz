//
//  YourCommentCell.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 8. 14..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit

class YourCommentCell: CommentCell {
	@IBOutlet weak var backgroundImgView: UIImageView!
	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var userProfileView: UIView!
	@IBOutlet weak var userNameLabel: UIView!
	
	override func didSetComment() {
		super.didSetComment()
		
		self.messageLabel.text = comment?.message
		self.userProfileView.layer.cornerRadius = 16
		self.userProfileView.layer.borderColor = UIColor.lavender.cgColor
		self.userProfileView.layer.borderWidth = 1
		
		messageLabel.bringSubview(toFront: backgroundImgView)

	}
}
