//
//  GameVC.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 23..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit
import Then
import SnapKit
import FirebaseAuth
import FirebaseDatabase


fileprivate let userCellID = "userCellID"

class GameVC: UIViewController {
	
	
	var gameUID: String? {
		didSet {
			self.fetchGame()
		}
	}
	
	var usersUID = [String]()

	
	var usersCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .vividPurple
		return cv
	}()
	
	let ref = Database.database().reference().child("games")
	
	var userCountButton: UIBarButtonItem! // right BarButtonItem
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
			
			let users = dic["users"] as? [String:Bool]
			self.setupNavBar(userCount: (users)?.count ?? 0)
//			self.usersUID = users?.keys as! [String]
			guard let keys = users?.keys else { return }
			let keysArray = Array(keys)
			self.usersUID = keysArray
			DispatchQueue.main.async {
				self.usersCollectionView.reloadData()
			}
			

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
		setupNavBar(userCount: 0)
		setupUsersCV()

	}
	
	/// 유저 목록 콜렉션뷰 추가
	private func setupUsersCV() {

		
		self.view.addSubview(usersCollectionView)
		
		usersCollectionView.snp.remakeConstraints { make -> Void in
			make.left.top.right.equalTo(self.view)
			make.height.equalTo(90)
		}
		
		usersCollectionView.register(UserCell.self, forCellWithReuseIdentifier: userCellID)
		usersCollectionView.delegate = self
		usersCollectionView.dataSource = self
	}
	
	
	private func setupNavBar(userCount: Int) {
		userCountButton = UIBarButtonItem(title: userCount > 0 ? String(userCount) : "", style: .done, target: self, action: #selector(didTapUserCount))
		self.navigationItem.rightBarButtonItem = userCountButton
	}
	@objc private func didTapUserCount() {
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		guard let gameUID = gameUID else { return }
		
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		ref.child(gameUID).child("users").child(uid).removeValue()
	}
	
}

extension GameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return usersUID.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userCellID, for: indexPath) as! UserCell
		
		cell.userUID = usersUID[indexPath.item]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 60, height: 86)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
	}
	
	
}
