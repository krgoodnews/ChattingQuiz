//
//  SocketIOManager.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 21..
//  Copyright © 2018년 Badoo. All rights reserved.
//

//import UIKit
//import SocketIO
//
//class SocketIOManager: NSObject {
//
//	static let shared = SocketIOManager()
//
//	//	var socket = SocketIOClient(socketURL: URL(string: Constants.controlServerAddress ?? "http://52.79.173.186:3100")!, config: [.nsp("/user")])
//
//
//	var manager: SocketManager = {
//		let manager = SocketManager(socketURL: URL(string: "http://13.229.145.72:8080/")!, config: [])
//
//
//		return manager
//	}()
//
//
//	override init() {
//		super.init()
//	}
//
//
//
//	/// 소켓 설정
//	func establishConnection(completion: (() -> Void)?) {
//		let socket = manager.defaultSocket
//		socket.connect()
//		print("-----------socket connected")
//		completion?()
//	}
//
//	/// 소켓 해제
//	func closeConnection() {
//		let socket = manager.defaultSocket
//
//		socket.disconnect()
//	}
//
//
//	func onStartGame(completion: @escaping ([Any]) -> ()) {
//		let socket = manager.defaultSocket
//
//		socket.on("start") {data, ack in
//			print("------------start game")
//			print(data)
//			completion(data)
//
//		}
//	}
//
//	func onSendChat(completion: @escaping ([Any]) -> ()) {
//		let socket = manager.defaultSocket
//
//		socket.on("send") {data, ack in
//			print("------------send chat")
//			print(data)
//			completion(data)
//		}
//	}
//
//	func onAnswer() {
//		let socket = manager.defaultSocket
//
//		socket.on("answer") {data, ack in
//			print("------------send chat")
//			print(data)
//		}
//	}
//
//	func onCorrect(completion: @escaping ([Any]) -> ()) {
//		let socket = manager.defaultSocket
//
//		socket.on("correct") {data, ack in
//			print("------------on correct")
//			print(data)
//			completion(data)
//		}
//	}
//
//	func onSend() {
//		let socket = manager.defaultSocket
//
//		socket.on("send") {data, ack in
//			print("------------on send")
//			print(data)
//		}
//	}
//
//	func emitSend() {
//		let socket = manager.defaultSocket
//
//		socket.emit("send", [])
//	}
//
//
//	func emitAnswer(_ text: String) {
//		let socket = manager.defaultSocket
//
//		socket.emit("correct", [text])
//	}
//
//	func emitStart() {
//		let socket = manager.defaultSocket
//		
//		socket.emit("start", [])
//	}
//
//
//}
