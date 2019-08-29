//
//  Game.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 23..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit

@objcMembers
class Game: NSObject {
	
	var gameUID: String = ""
	var gameName: String?
	
	var bossUID: String? // 방장 유저 UID
	
	var usersCount: Int = 0
	
	
	public var users: Dictionary<String, Bool> = [:] // 채팅방 참여자
	public var comments: [String:Any] = [:] // 채팅방 내용
	
	@objcMembers
	public class Comment: NSObject {
		var uid: String?
		var userUID: String? // 보낸 유저의 uid
		var message: String?
		var timeStamp: Int?
	}
}
