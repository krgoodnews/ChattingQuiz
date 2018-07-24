//
//  Chat.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 24..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit

class Chat: NSObject {
	public var users: Dictionary<String, Bool> = [:] // 채팅방 참여자
	public var comments: Dictionary<String, Comment> = [:] // 채팅방 내용
	
	public class Comment {
		public var uid: String?
		public var message: String?
	}
	
}
