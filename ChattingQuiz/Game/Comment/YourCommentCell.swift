//
//  YourCommentCell.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 8. 14..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class YourCommentCell: CommentCell {
	@IBOutlet weak var backgroundImgView: UIImageView!
	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var userProfileView: UIView!
	@IBOutlet weak var userNameLabel: UILabel!
	
	
	override func didSetComment() {
		super.didSetComment()
		
		self.messageLabel.text = comment?.message
		self.userProfileView.layer.cornerRadius = 16
		self.userProfileView.layer.borderColor = UIColor.lavender.cgColor
		self.userProfileView.layer.borderWidth = 1
		
		messageLabel.bringSubview(toFront: backgroundImgView)
		
		
		
		let ref = Database.database().reference()
		guard let uid = comment?.userUID else { return }
		ref.child("users").child(uid).observe(.value) { (snapshot) in
			let value = snapshot.value as? NSDictionary
			guard let name = value?["name"] as? String else { return }
			let index = name.index(name.startIndex, offsetBy: 2)
			let substringName = name.substring(to: index)  // Hello
			self.userNameLabel.text = substringName
			
		}

	}
}
