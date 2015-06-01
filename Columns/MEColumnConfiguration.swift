//
//  ColumnConfiguration.swift
//  ColumnView
//
//  Created by Michael Emmons on 4/26/15.
//  Copyright (c) 2015 App Apps, LLC. All rights reserved.
//

import Foundation
import UIKit

@objc public class MEColumnConfiguration : NSObject {

	let view: UIView
	let minWidth: NSNumber
	let separatorColor: UIColor?
	let separatorWidth: NSNumber?

	init(view: UIView, minWidth:NSNumber, separatorColor: UIColor, separatorWidth: NSNumber) {
		self.view = view
		self.minWidth = minWidth;
		self.separatorColor = separatorColor
		self.separatorWidth = separatorWidth
	}
}
