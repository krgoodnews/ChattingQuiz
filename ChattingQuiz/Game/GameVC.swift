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
fileprivate let messageCellID = "messageCellID"

/*
한 게임의 컨트롤러이다.
collectionView: 유저 목록 표시
tableView: 채팅 표시
*/
class GameVC: UIViewController {
	
	var gameUID: String? {
		didSet {
			self.fetchGame()
		}
	}
	
	var usersUID = [String]()

	// MARK: Views
	
	var usersCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .vividPurple
		return cv
	}()
	
	var messagesTableView = UITableView().then {
		$0.backgroundColor = .groupTableViewBackground
	}
	
	var inputBar = ChatInputBar.initFromNib()

	let ref = Database.database().reference().child("games")
	
	var userCountButton: UIBarButtonItem! // right BarButtonItem
	
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
			self.setUserNavButton(userCount: (users)?.count ?? 0)
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
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
	}
	@objc func keyboardWillShow(notification : Notification){
		
		if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
			
			let height = keyboardSize.height
			inputBar.snp.updateConstraints { make -> Void in
				make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-height)
			}

		}
		
		UIView.animate(withDuration: 0, animations: {
			self.view.layoutIfNeeded()
		}, completion: {
			(complete) in
			
//			if self.comments.count > 0{
//				self.tableview.scrollToRow(at: IndexPath(item:self.comments.count - 1,section:0), at: UITableViewScrollPosition.bottom, animated: true)
//
//			}
//
			
		})
	}
	
	@objc func keyboardWillHide(notification : Notification){
		
		inputBar.snp.updateConstraints { make -> Void in
			make.bottom.equalTo(self.view.safeAreaLayoutGuide)
		}
		
		
	}
	
	private func enterUser() {
		guard let gameUID = gameUID else { return }
		guard let userUID = Auth.auth().currentUser?.uid else { return }
		let value = [userUID: true]
		
		ref.child(gameUID).child("users").updateChildValues(value)
	}
	
	func setupView() {
		setUserNavButton(userCount: 0)
		
		setupNavBar()
		
		view.addSubview(inputBar)

		inputBar.snp.remakeConstraints { make -> Void in
			make.left.right.equalTo(self.view)
			make.bottom.equalTo(self.view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
		
		setupUsersCV()
		
		setupMessagesTV()

	}
	private func setupNavBar() {
		self.navigationItem.hidesBackButton = true
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		
		// TODO: 백버튼 색깔 하얀색으로 바꾸기
		let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "iconBack"), style: .plain, target: self, action: #selector(didTapBack))
		self.navigationItem.leftBarButtonItem = backButton
	}
	
	@objc private func didTapBack() {
		let alert = UIAlertController(title: "정말 나가시겠습니까?", message: nil, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "나가기", style: .destructive) { _ in
			self.navigationController?.popViewController(animated: true)
		}
		let cancelAction = UIAlertAction(title: "아니오", style: .cancel)
		
		alert.addAction(okAction)
		alert.addAction(cancelAction)
		
		self.present(alert, animated: true, completion: nil)
	}
	private func setupMessagesTV() {
		self.view.addSubview(messagesTableView)
		
		messagesTableView.snp.remakeConstraints { make -> Void in
			make.top.equalTo(usersCollectionView.snp.bottom)
			make.left.right.equalTo(self.view)
			make.bottom.equalTo(inputBar.snp.top)
		}
		
		messagesTableView.delegate = self
		messagesTableView.dataSource = self

		messagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: messageCellID)
		
		messagesTableView.keyboardDismissMode = .onDrag
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
	
	
	private func setUserNavButton(userCount: Int) {
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

// MARK: Collection View
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

// MARK: Table View

extension GameVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID, for: indexPath)
		
		return cell
	}
	
	
}
