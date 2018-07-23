//
//  CreateGameRoom.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 21..
//  Copyright © 2018년 Badoo. All rights reserved.
//

import UIKit

class CreateGameRoomView: UIView {
	
	@IBOutlet weak var boxView: UIView!
	@IBOutlet weak var titleView: UIView!
	
	@IBOutlet weak var createRoomButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupView()
	}
	
	static func initFromNib() -> CreateGameRoomView {
		return Bundle.main.loadNibNamed("CreateGameRoom", owner: self, options: nil)?.first as! CreateGameRoomView
	}
	
	private func setupView() {
		boxView.layer.cornerRadius = 4
		titleView.layer.cornerRadius = 4
		
		createRoomButton.layer.cornerRadius = 22
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
		self.addGestureRecognizer(gesture)
	}
	
	@objc private func didTapBackground() {
		self.endEditing(true)

		UIView.animate(withDuration: 0.3, animations: {
			self.alpha = 0
		}) { (_) in
			self.removeFromSuperview()
		}
	}
}
