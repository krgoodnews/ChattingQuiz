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
	
	var gameState: GameStateType = .wait {
		didSet {
			didSetState()
		}
	}
	
	func didSetState() {
		self.titleButton.gameState = gameState
		
		switch gameState {
			
		case .wait:
			titleButton.snp.updateConstraints { make -> Void in
				make.top.equalTo(self).offset(10)
				make.centerX.equalTo(self)
				make.size.equalTo(CGSize(width: 272, height: 44))
			}
			
			correctImgView.isHidden = true
			questionLabel.isHidden = true
			correctLabel.isHidden = true
			
		case .standby:
			break
		case .play:
			titleButton.snp.updateConstraints { make -> Void in
				make.top.equalTo(self).offset(10)
				make.centerX.equalTo(self)
				make.size.equalTo(CGSize(width: 76, height: 24))
			}
			correctImgView.isHidden = false
			questionLabel.isHidden = false
			correctLabel.isHidden = false
			
		case .correct:
			break
		case .finish:
			break
		}
	}
	
	// MARK: View
	let correctImgView = UIImageView().then {
		$0.image = #imageLiteral(resourceName: "graphicCorrect")
		$0.contentMode = .scaleAspectFit
	}
	
	let titleButton = PlayGameTitleButton()
	
	let questionLabel = UILabel().then {
		$0.textColor = .white
		$0.textAlignment = .center
		$0.font = .systemFont(ofSize: 28, weight: .bold)
//		$0.text = "ㅇㄴㅎㅅㄴㄲ"
		let attributedString = NSMutableAttributedString(string: "ㅇㄴㅎㅅㄴㄲ ㅇㄴㅎㅅㄴㄲ ㅇㄴㅎㅅㄴㄲ ㅇㄴㅎㅅㄴㄲ ㅇㄴㅎㅅㄴㄲ ")
		attributedString.addAttribute(NSAttributedStringKey.kern, value: 6, range: NSRange(location: 0, length: attributedString.length))
		$0.attributedText = attributedString
		$0.adjustsFontSizeToFitWidth = true
		$0.minimumScaleFactor = 0.5
		$0.numberOfLines = 2
	}
	
	let correctLabel = UILabel().then {
		$0.text = "일이삼사오륙칠팔 님이 정답을 맞추셨습니다!"
		$0.textColor = .white
		$0.textAlignment = .center
		$0.font = .systemFont(ofSize: 13, weight: .bold)
	}
	
	
	func setupView() {
		self.backgroundColor = .vividPurple
		addSubviews(correctImgView, titleButton, questionLabel, correctLabel)
		
		correctImgView.snp.remakeConstraints { make -> Void in
			make.top.equalTo(self).offset(8)
			make.bottom.equalTo(correctLabel.snp.top).offset(-4)
			make.left.right.equalTo(self)
		}

		titleButton.snp.updateConstraints { make -> Void in
			make.top.equalTo(self).offset(10)
			make.centerX.equalTo(self)
			make.size.equalTo(CGSize(width: 272, height: 44))
		}
		
		questionLabel.snp.remakeConstraints { make -> Void in
			make.top.equalTo(titleButton.snp.bottom).offset(16)
			make.left.right.equalTo(self).inset(8)
		}

		
		correctLabel.snp.remakeConstraints { make -> Void in
			make.bottom.equalTo(self).offset(-24)
			make.centerX.equalTo(self)
		}

		
	}
	// MARK: Func
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

}

enum GameStateType {
	case wait
	case standby
	case play
	case correct
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
			self.layer.cornerRadius = 12
			self.backgroundColor = .white
			self.setTitle("-- ROUND", for: .normal)
			self.setTitleColor(.vividPurple, for: .normal)
			self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
		case .finish:
			break
		case .correct:
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
