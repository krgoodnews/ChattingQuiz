//
//  GameVC.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 23..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit
import FirebaseAuth

class GameVC: UIViewController {
	
	@IBOutlet weak var sendButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
	}
	
	func createRoom() {
		let createRoomInfo = [
			"uid": Auth.auth().currentUser?.uid
		]
	}

}
