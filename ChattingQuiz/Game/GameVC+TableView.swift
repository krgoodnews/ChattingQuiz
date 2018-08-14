//
//  GameVC+TableView.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 8. 14..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit

// MARK: Table View

extension GameVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID, for: indexPath)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
}

