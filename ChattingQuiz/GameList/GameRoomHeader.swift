//
//  GameRoomHeader.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 20..
//  Copyright © 2018년 Badoo. All rights reserved.
//

import UIKit

class GameRoomHeader: UICollectionReusableView {
	@IBOutlet weak var createRoomButton: UIButton!
	override func awakeFromNib() {
		super.awakeFromNib()
		
		createRoomButton.layer.cornerRadius = 24
	}
}
