//
//  GameVC+TableView.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 8. 14..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit
import FirebaseAuth

// MARK: Table View

extension GameVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comments.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: myMessageCellID, for: indexPath) as! MyCommentCell

//		cell.textLabel?.text = comments[indexPath.row].message
		var cell: CommentCell
		let comment = self.comments[indexPath.row]
		
		if comment.userUID == Auth.auth().currentUser?.uid {
			cell = tableView.dequeueReusableCell(withIdentifier: myMessageCellID, for: indexPath) as! MyCommentCell
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: yourMessageCellID, for: indexPath) as! YourCommentCell

		}
		cell.comment = comment
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	
}

