//
//  SignUpVC.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 20..
//  Copyright © 2018년 Badoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseDatabase

fileprivate let minUsernameLength = 2
fileprivate let maxUsernameLength = 8

class SignUpVC: ViewController {
	
	@IBOutlet weak var usernameTextField: UITextField!
	
	
	@IBOutlet weak var usernameValidLabel: UILabel!
	
	@IBOutlet weak var startButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupRx()
	}
	
	private func setupViews() {
		usernameValidLabel.text = "닉네임은 \(minUsernameLength)~\(maxUsernameLength)자여야 합니다."
		
		startButton.layer.cornerRadius = 20
	}
	
	private func setupRx() {
		
		let usernameValid = usernameTextField.rx.text.orEmpty
			.map { minUsernameLength <= $0.count && $0.count <= maxUsernameLength }
			.share(replay: 1)
		
		usernameValid	// 형식에 맞으면 ValidLabel 숨기기
			.bind(to: usernameValidLabel.rx.isHidden)
			.disposed(by: disposeBag)
		
		usernameValid	// 형식에 맞으면 시작버튼 활성화
			.bind(to: startButton.rx.isEnabled)
			.disposed(by: disposeBag)
		
		startButton.rx.tap
			.subscribe(onNext: { [weak self] _ in self?.signUp() })
			.disposed(by: disposeBag)
		
	}
	
	func signUp() {

		Auth.auth().signInAnonymously { (user, error) in
			
			guard error == nil else {
				print(error ?? "")
				return
			}
			
			
			guard let uid = Auth.auth().currentUser?.uid else { return }
			guard let username = self.usernameTextField.text else { return }
			print("---uid: \(uid), username: \(username)")
			
			let values = ["name":username, "uid": Auth.auth().currentUser?.uid]
			Database.database().reference().child("users").child(uid).setValue(values, withCompletionBlock: { (err, ref) in
				self.presentGameListVC()
			})
			
		}
		

	}
	
	private func presentGameListVC() {
		guard let gameListVC = UIStoryboard(name: "GameList", bundle: nil).instantiateInitialViewController() else { return }
		
		self.present(gameListVC, animated: true, completion: nil)
	}
}
