//
//  GameRoomCell.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 20..
//  Copyright © 2018년 Badoo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GameRoomCell: UICollectionViewCell {
	
	var game: Game? {
		didSet {
			guard let game = game else { return }
			self.titleLabel.text = game.gameName
			
			// set Boss's name
			let ref = Database.database().reference()
			ref.child("users").child(game.bossUID ?? "").observe(.value) { (snapshot) in
				let value = snapshot.value as? NSDictionary
				let name = value?["name"] as? String
				self.bossLabel.text = name
			}
			
			// set UserCount
			self.userCountLabel.text = "\(game.usersCount)명"
			
		}
	}
	@IBOutlet weak var bossLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var userCountLabel: UILabel!
	
	@IBOutlet weak var seperatorLine: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		seperatorLine.layer.cornerRadius = 1
		self.layer.cornerRadius = 4
	}
}
