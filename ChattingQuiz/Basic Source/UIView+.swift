//
//  UIView+.swift
//  ChattingQuiz
//
//  Created by Goodnews on 2018. 7. 26..
//  Copyright © 2018년 krgoodnews. All rights reserved.
//

import UIKit


extension UIView {
	
	func addSubviews(_ views: UIView...) {
		for view in views {
			self.addSubview(view)
		}
	}
}
