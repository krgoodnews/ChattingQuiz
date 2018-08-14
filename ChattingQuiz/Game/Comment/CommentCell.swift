//
//  CommentCell.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 8. 14..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
	
	var comment: Game.Comment? {
		didSet {
			didSetComment()
		}
	}
	
	func didSetComment() {
		
	}
}
