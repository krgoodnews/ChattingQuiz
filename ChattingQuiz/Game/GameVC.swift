//
//  GameVC.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 23..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class GameVC: UIViewController {
	
//	var : Game? {
//		didSet {
//			self.title = game?.gameName
//		}
//	}
	
	var gameUID: String? {
		didSet {
			self.fetchGame()
		}
	}
	
	let ref = Database.database().reference().child("games")
	
	@IBOutlet weak var sendButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		setupView()
	}
	
	func fetchGame() {
		guard let uid = gameUID else { return }
		ref.child(uid).observe(.value) { (snapshot) in
			let dic = snapshot.value as! [String:Any]
			self.title = dic["gameName"] as? String ?? ""
			
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		enterUser()
	}
	
	private func enterUser() {
		guard let gameUID = gameUID else { return }
		guard let userUID = Auth.auth().currentUser?.uid else { return }
		let value = [userUID: true]
		
		ref.child(gameUID).child("users").updateChildValues(value)
	}
	
	func setupView() {
//		print(game)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		
//		guard let game = game else { return }
//		guard let uid = Auth.auth().currentUser?.uid else { return }
//
//		ref.child("games").child(game.gameUID).child("users").child(uid).removeValue()
		
	}
	
	
}
