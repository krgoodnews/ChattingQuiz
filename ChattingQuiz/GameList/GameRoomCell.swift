//
//  GameRoomCell.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 20..
//  Copyright © 2018년 Badoo. All rights reserved.
//

import UIKit

class GameRoomCell: UICollectionViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var seperatorLine: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		seperatorLine.layer.cornerRadius = 1
		self.layer.cornerRadius = 4
	}
}
