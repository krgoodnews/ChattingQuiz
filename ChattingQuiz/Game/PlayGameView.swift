//
//  PlayGameView.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 8. 15..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit
import Then
import SnapKit

class PlayGameView: UIView {
	let titleButton = PlayGameTitleButton()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		self.backgroundColor = .vividPurple
		addSubviews(titleButton)
		
		titleButton.snp.updateConstraints { make -> Void in
			make.top.equalTo(self).offset(10)
			make.centerX.equalTo(self)
			make.size.equalTo(CGSize(width: 272, height: 44))
		}


	}
}

enum GameStateType {
	case wait
	case standby
	case play
	case finish
}
class PlayGameTitleButton: UIButton {
	var gameState: GameStateType = .wait {
		didSet {
			didSetState()
		}
	}
	
	func didSetState() {
		switch gameState {
		
		case .wait:
			self.layer.cornerRadius = 22
			self.backgroundColor = .sunflower
			self.setTitle("지금 게임 시작하기", for: .normal)
			self.setTitleColor(.vividPurple, for: .normal)
			self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		case .standby:
			break
		case .play:
			break
		case .finish:
			break
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		didSetState()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
