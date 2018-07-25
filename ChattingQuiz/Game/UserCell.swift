//
//  UserCell.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 26..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit
import Then
import SnapKit
import FirebaseDatabase
import FirebaseAuth

class UserCell: UICollectionViewCell {
	
	var userUID: String? {
		didSet {
			fetchUser()
		}
	}
	
	let ref = Database.database().reference()
	
	private func fetchUser() {
		guard let uid = userUID else { return }
		ref.child("users").child(uid).observe(.value) { (snapshot) in
			let value = snapshot.value as? NSDictionary
			guard let name = value?["name"] as? String else { return }
			let index = name.index(name.startIndex, offsetBy: 2)
			let substringName = name.substring(to: index)  // Hello
			self.profileLabel.text = substringName
			self.nameLabel.text = name
		}
	}
	
	let profileLabel = UILabel().then {
		$0.layer.cornerRadius = 20
		$0.layer.borderColor = UIColor.white.cgColor
		$0.layer.borderWidth = 1
		$0.textColor = .white
		$0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
		$0.textAlignment = .center
	}
	
	let nameLabel = UILabel().then {
		$0.textColor = .white
		$0.numberOfLines = 2
		$0.textAlignment = .center
		$0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		addSubviews(profileLabel, nameLabel)

		profileLabel.snp.remakeConstraints { make -> Void in
			make.top.equalTo(self).inset(12)
			make.centerX.equalTo(self)
			make.size.equalTo(40)
		}
		
		nameLabel.snp.remakeConstraints { make -> Void in
			make.top.equalTo(profileLabel.snp.bottom).offset(4)
			make.left.right.equalTo(self).inset(4)
		}


	}
	
}
