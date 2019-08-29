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



/*
한 게임의 컨트롤러이다.
collectionView: 유저 목록 표시
tableView: 채팅 표시
*/
class GameVC: UIViewController {
	
	// MARK: Cells & Games ID
	let userCellID = "userCellID"
	let myMessageCellID = "myMessageCellID"
	let yourMessageCellID = "yourMessageCellID"

	
	var gameUID: String? {
		didSet {
			self.fetchGame()
		}
	}
	
	var isHideUserCV = false {
		didSet {
			usersCollectionView.snp.updateConstraints { make -> Void in
				make.height.equalTo(isHideUserCV ? 0 : 80)
			}
			
			UIView.animate(withDuration: 0.3, animations: {
				self.view.layoutIfNeeded()
			})
		}
	}
	
	var gameState: GameStateType = .wait {
		didSet {
			didSetState()
		}
	}
	
	var usersUID = [String]()
	var comments: [Game.Comment] = []
	
	// MARK: Views
	
	var usersCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .vividPurple
		return cv
	}()
	
	let playGameView = PlayGameView()
	
	let messagesTableView = UITableView()
	
	var inputBar = ChatInputBar.initFromNib()

	let ref = Database.database().reference().child("games")
	
	var userCountButton: UIBarButtonItem! // right BarButtonItem
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
	}
	
	
	func setupView() {
		setUserNavButton(userCount: 0)
		
		setupNavBar()
		
		view.addSubviews(usersCollectionView, playGameView, inputBar, messagesTableView)
		
		
		usersCollectionView.snp.remakeConstraints { make -> Void in
			make.left.top.right.equalTo(self.view)
			make.height.equalTo(80)
		}
		
		playGameView.snp.remakeConstraints { make -> Void in
			make.top.equalTo(usersCollectionView.snp.bottom)
			make.left.right.equalTo(self.view)
			make.height.equalTo(80)
		}

		
		inputBar.snp.remakeConstraints { make -> Void in
			make.left.right.equalTo(self.view)
			make.bottom.equalTo(self.view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
		
		
		messagesTableView.snp.remakeConstraints { make -> Void in
			make.top.equalTo(playGameView.snp.bottom)
			make.left.right.equalTo(self.view)
			make.bottom.equalTo(inputBar.snp.top)
		}
		
		inputBar.sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
		
		setupUsersCV()
		
		setupMessagesTV()
		
	}
	
	@objc private func didTapSend() {
		print("didTapSend")
		guard inputBar.messageTextField.text! != "" else { return }
		guard let userUID = Auth.auth().currentUser?.uid else { return }

		let value : Dictionary<String,Any> = [
			"userUID": userUID,
			"message": inputBar.messageTextField.text!,
			"timeStamp" : ServerValue.timestamp()
		]
		
		self.inputBar.messageTextField.text = ""

		ref.child(gameUID ?? "error").child("comments").childByAutoId().setValue(value) { (err, ref) in
			
			self.ref.child(self.gameUID ?? "error").child("comments").observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
				let dic = datasnapshot.value as! [String:Any]
				
				print(dic)

				self.scrollToBottom()
			})
		}
	}
	
	func scrollToBottom(animate: Bool = false){
		
		DispatchQueue.main.async {
			guard self.comments.count > 0 else { return }
			
			let lastRow = self.comments.count - 1
			let indexPath = IndexPath(row: lastRow, section: 0)
			
			self.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: animate)
			
		}
		
	}
	
	func fetchGame() {
		guard let uid = gameUID else { return }
		ref.child(uid).observe(.value) { (snapshot) in
			guard let dic = snapshot.value as? [String:Any] else { return }
			self.title = dic["gameName"] as? String ?? ""
			
			// set Users
			let users = dic["users"] as? [String:Bool]
			self.setUserNavButton(userCount: (users)?.count ?? 0)
			guard let keys = users?.keys else { return }
			let keysArray = Array(keys)
			self.usersUID = keysArray
			DispatchQueue.main.async {
				self.usersCollectionView.reloadData()
			}
			
			// set commnets
			guard let comments = dic["comments"] as? [String: Any] else { return }
//			guard let commentKeys = comments?.keys else { return }
//			let commentKeysArray = Array(commentKeys)
//			self.comments = commentKeysArray
//
			self.comments.removeAll()
			for child in comments {
				let comment = Game.Comment()
				comment.uid = child.key
				let value = child.value as! [String: Any]
//				comment.setValuesForKeys(value)
				comment.userUID = value["userUID"] as? String
				comment.timeStamp = value["timeStamp"] as? Int
				comment.message = value["message"] as? String
				self.comments.append(comment)
			}
			self.comments = self.comments.sorted(by: { $0.timeStamp! < $1.timeStamp! })
			DispatchQueue.main.async {
				self.scrollToBottom()
				self.messagesTableView.reloadData()
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		enterUser()
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
		playGameView.titleButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
	}
	
	@objc private func didTapStart() {
		self.gameState = .play
		
	}
	@objc func keyboardWillShow(notification : Notification){
		self.scrollToBottom()
		isHideUserCV = true

		if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
			
			let height = keyboardSize.height
			inputBar.snp.updateConstraints { make -> Void in
				make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-height)
				make.height.equalTo(44)
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
		messagesTableView.allowsSelection = false
		messagesTableView.separatorStyle = .none
		
		
		messagesTableView.delegate = self
		messagesTableView.dataSource = self

		messagesTableView.register(UINib(nibName: "MyCommentCell", bundle: nil), forCellReuseIdentifier: myMessageCellID)
		messagesTableView.register(UINib(nibName: "YourCommentCell", bundle: nil), forCellReuseIdentifier: yourMessageCellID)
		messagesTableView.keyboardDismissMode = .onDrag
	}
	
	/// 유저 목록 콜렉션뷰 추가
	private func setupUsersCV() {
		usersCollectionView.register(UserCell.self, forCellWithReuseIdentifier: userCellID)
		usersCollectionView.delegate = self
		usersCollectionView.dataSource = self
	}
	
	
	private func setUserNavButton(userCount: Int) {
		userCountButton = UIBarButtonItem(title: userCount > 0 ? String(userCount) : "", style: .done, target: self, action: #selector(didTapUserCount))
		self.navigationItem.rightBarButtonItem = userCountButton
	}
	@objc private func didTapUserCount() {
		isHideUserCV = !isHideUserCV
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
	
	func didSetState() {
		playGameView.gameState = gameState
		
		switch gameState {
			
		case .wait:
			playGameView.snp.updateConstraints { make -> Void in
				make.height.equalTo(80)
			}

		case .standby:
			self.isHideUserCV = true
			playGameView.snp.updateConstraints { make -> Void in
				make.height.equalTo(164)
			}
		case .play:
			self.isHideUserCV = true
			playGameView.snp.updateConstraints { make -> Void in
				make.height.equalTo(164)
			}
		case .finish:
			self.isHideUserCV = true
			playGameView.snp.updateConstraints { make -> Void in
				make.height.equalTo(164)
			}
		case .correct:
			break
		}
		
		UIView.animate(withDuration: 0.3, animations: {
			self.view.layoutIfNeeded()
		})
	}
	
}


