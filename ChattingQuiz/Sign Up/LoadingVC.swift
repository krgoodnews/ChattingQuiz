//
//  LoadingVC.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 22..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoadingVC: ViewController {
	
	let imgView = UIImageView(image: #imageLiteral(resourceName: "logoSplash"))
	var remoteConfig: RemoteConfig!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		setupFirebase()
		setupViews()
	}
	
	private func setupFirebase() {
		remoteConfig = RemoteConfig.remoteConfig()
		remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)

		remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
		
		fetchConfig()

		

	}
	
	private func fetchConfig() {
		remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
			if status == .success {
				print("---  Config fetched!")
				self.remoteConfig.activateFetched()
			} else {
				print("---  Config not fetched")
				print("Error: \(error?.localizedDescription ?? "No error available.")")
			}
			self.didFetchComplete()
		}
	}
	
	func didFetchComplete() {
		let caps = remoteConfig["splash_message_caps"].boolValue
		let message = remoteConfig["splash_message"].stringValue
		
		if caps { // caps == true 인 경우 앱 종료 공지 띄우기
			let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: .alert)
			
			alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
				exit(0)
			}))
			
			self.present(alert, animated: true)
			
		} else { // 로그인 화면으로 넘어가기
			
			if let _ = Auth.auth().currentUser?.uid { // 이미 로그인 되어있을시
				guard let gameListVC = UIStoryboard(name: "GameList", bundle: nil).instantiateInitialViewController() else { return }
				
				self.present(gameListVC, animated: true, completion: nil)
			} else {
				guard let signUpVC = UIStoryboard(name: "SignUp", bundle: nil).instantiateInitialViewController() else { return }
				
				self.present(signUpVC, animated: true)
			}

			
			
		}
		
//		self.view.backgroundColor = UIColor(color ?? "#FFFFFF")
		
	}
	
	private func setupViews() {
		view.addSubview(imgView)

		imgView.snp.remakeConstraints { make -> Void in
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).offset(-60)
		}

	}
	
}
