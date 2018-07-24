//
//  GameListVC.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 20..
//  Copyright © 2018년 Badoo. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import FirebaseDatabase
import FirebaseAuth

fileprivate let cellID = "gameRoomCellID"
fileprivate let headerID = "gameRoomHeader"
class GameListVC: ViewController {
	
	
	
	@IBOutlet weak var nicknameOutlet: UIBarButtonItem!
	@IBOutlet weak var collectionView: UICollectionView!
	var games = [Game]()
	var ref: DatabaseReference! = Database.database().reference()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavBar()
		setupCollectionView()
		//		setupRx()
		fetchGames()
	}
	
	private func fetchGames() {
		ref.child("gameRooms").observe(.value) { (snapshot) in
			self.games.removeAll()
			
			for child in snapshot.children {
				guard let fchild = child as? DataSnapshot else { continue }
				let game = Game()
				game.setValuesForKeys(fchild.value as! [String:Any])
				
				self.games.append(game)
			}
			
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	private func setupNavBar() {

		addNameButton()
		addImageTitle()
		
		self.navigationController?.navigationBar.shadowImage = UIImage()
	}
	
	fileprivate func addImageTitle() {
		let image : UIImage = #imageLiteral(resourceName: "navTitle")
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 68, height: 17))
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		self.navigationItem.titleView = imageView
	}
	
	private func addNameButton() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		self.ref.child("users").child(uid).observe(DataEventType.value) { (snapshot) in
			let dict = snapshot.value as? [String: Any] ?? [:]
			let userName = dict["name"] as? String
			let nicknameButton = UIBarButtonItem(title: userName, style: .done, target: self, action: nil)
			self.navigationItem.rightBarButtonItem = nicknameButton
		}
		
	}
	private func setupCollectionView() {
		collectionView.register(UINib(nibName: "GameRoomCell", bundle: nil), forCellWithReuseIdentifier: cellID)
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
	}
	
	@objc private func didTapCreateRoom() {
		let createGameView = CreateGameView.initFromNib()
		createGameView.delegate = self

		
		
		let window = UIApplication.shared.keyWindow
		window?.addSubview(createGameView)
		
		createGameView.snp.remakeConstraints { make -> Void in
			make.edges.equalTo(window!)
		}
	}
	
	
	// 게임에 입장한다
	private func enterGame(_ game: Game) {
		guard let gameVC = UIStoryboard(name: "Game", bundle: nil).instantiateInitialViewController() as? GameVC else { return }
		gameVC.game = game
		self.navigationController?.pushViewController(gameVC, animated: true)
	}
}

extension GameListVC: CreateGameDelegate {
	func didCreateGame(game: Game) {
		self.enterGame(game)
	}
}

extension GameListVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width: CGFloat = self.view.frame.width - 44
		let height: CGFloat = 104
		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return games.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GameRoomCell
		
		cell.game = games[indexPath.item]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 16
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 16
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let gameVC = UIStoryboard(name: "Game", bundle: nil).instantiateInitialViewController() else { return }
		self.navigationController?.pushViewController(gameVC, animated: true)
	}
	
	
	//
	// Header & footer
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! GameRoomHeader
		
		headerView.createRoomButton.addTarget(self, action: #selector(didTapCreateRoom), for: .touchUpInside)
		return headerView
		
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		let width:CGFloat = self.view.frame.width
		let height:CGFloat = 200
		
		return CGSize(width: width, height: height)
	}
}


