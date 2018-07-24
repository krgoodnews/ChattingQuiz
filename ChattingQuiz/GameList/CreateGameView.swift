//
//  CreateGame.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 21..
//  Copyright © 2018년 Badoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseDatabase
import FirebaseAuth

fileprivate let minNameLength = 2
fileprivate let maxNameLength = 30

protocol CreateGameDelegate {
	func didCreateGame(game: Game)
}

class CreateGameView: UIView {
	
	var delegate: CreateGameDelegate?
	
	@IBOutlet weak var boxView: UIView!
	@IBOutlet weak var titleView: UIView!
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var guideButton: UIButton!
	
	@IBOutlet weak var createRoomButton: UIButton!

	let ref = Database.database().reference()
	let disposeBag = DisposeBag()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupView()
		setupRx()
	}
	
	static func initFromNib() -> CreateGameView {
		return Bundle.main.loadNibNamed("CreateGame", owner: self, options: nil)?.first as! CreateGameView
	}
	
	private func setupRx() {
		
		let roomnameValid = nameTextField.rx.text.orEmpty
			.map { minNameLength <= $0.count && $0.count <= maxNameLength }
			.share(replay: 1)
		
		roomnameValid	// 형식에 맞으면 ValidLabel 숨기기
			.bind(to: guideButton.rx.isHidden)
			.disposed(by: disposeBag)
		
		roomnameValid	// 형식에 맞으면 시작버튼 활성화
			.bind(to: createRoomButton.rx.isEnabled)
			.disposed(by: disposeBag)
		
		createRoomButton.rx.tap
			.subscribe({ [weak self] _ in self?.didTapCreateRoom() })
			.disposed(by: disposeBag)
		
	}
	
	private func setupView() {
		boxView.layer.cornerRadius = 4
		titleView.layer.cornerRadius = 4
		
		createRoomButton.layer.cornerRadius = 22
		
		guideButton.titleLabel?.adjustsFontSizeToFitWidth = true
		guideButton.titleLabel?.minimumScaleFactor = 0.5
		guideButton.setTitle("방 이름은 \(minNameLength)~\(maxNameLength)자여야 합니다.", for: .normal)
		
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
		self.addGestureRecognizer(gesture)
		
		self.alpha = 0
		UIView.animate(withDuration: 0.3, animations: {
			self.alpha = 1
		})
	}
	
	private func didTapCreateRoom() {
		var createRoomInfo = [
			"bossUID": Auth.auth().currentUser?.uid,
			"gameName": nameTextField.text!
		]

		ref.child("gameRooms").childByAutoId().setValue(createRoomInfo) { (err, ref) in
			createRoomInfo["gameUID"] = ref.key
			
			let createdGame = Game()
			print(createRoomInfo)
			createdGame.setValuesForKeys(createRoomInfo)
			
			self.delegate?.didCreateGame(game: createdGame)
			self.closeEvent()
		}
	}
	
	@objc private func didTapBackground() {
		self.endEditing(true)
	}
	
	@IBAction func didTapClose(_ sender: UIButton) {
		self.closeEvent()
	}
	
	private func closeEvent() {
		self.endEditing(true)
		
		UIView.animate(withDuration: 0.3, animations: {
			self.alpha = 0
		}) { (_) in
			self.removeFromSuperview()
		}
	}
}
