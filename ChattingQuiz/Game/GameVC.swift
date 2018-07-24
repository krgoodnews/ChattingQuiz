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
	
	var game: Game? {
		didSet {
			self.title = game?.gameName
		}
	}
	
	@IBOutlet weak var sendButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		setupView()
	}
	
	func setupView() {
		print(game)
	}
	
	

}
