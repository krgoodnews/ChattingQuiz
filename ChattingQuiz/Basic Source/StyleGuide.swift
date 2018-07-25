//
//  StyleGuide.swift
//  ChattoApp
//
//  Created by Goodnews on 2018. 7. 21..
//  Copyright © 2018년 Badoo. All rights reserved.
//

import UIKit

// Color palette

extension UIColor {
	
	@nonobjc class var lavender: UIColor {
		return UIColor(red: 178.0 / 255.0, green: 76.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
	}
	
	@nonobjc class var vividPurple: UIColor {
		return UIColor(red: 200 / 255.0, green: 85.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
	}
	
	@nonobjc class var liliac: UIColor {
		return UIColor(red: 209.0 / 255.0, green: 148.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
	}
	
	@nonobjc class var sunflower: UIColor {
		return UIColor(red: 1.0, green: 215.0 / 255.0, blue: 0.0, alpha: 1.0)
	}

}

// Sample text styles

extension UIFont {
	
	class var header: UIFont {
		return UIFont.systemFont(ofSize: 24.0, weight: .bold)
	}
	
}
