//
//  TitleValueViews.swift
//  Columns
//
//  Created by Michael Emmons on 5/11/15.
//  Copyright (c) 2015 App Apps, LLC. All rights reserved.
//

import Foundation
import UIKit

@objc public class METitleValueViews : UIView {

	private var customConstraintsInstalled = false
	private let titleValueViews : [METitleValueView]

	init(titleValueViews: [METitleValueView],  minimumHeight: Float) {
		self.titleValueViews = titleValueViews
		super.init(frame: CGRectZero)
		setTranslatesAutoresizingMaskIntoConstraints(false)
		configure()
	}

	required public init(coder aDecoder: NSCoder) {
		fatalError("NSCoding not supported. Class must be created programatically.")
	}


	private func configure() {
		for titleValueView in titleValueViews {
			addSubview(titleValueView)
		}
	}

	public override func updateConstraints() {
		if (customConstraintsInstalled == false) {
			customConstraintsInstalled = true
			removeConstraints(constraints())

			var rootConstraints = Array<AnyObject>()
			var formatString = ""
			for (index, titleValueView) in enumerate(titleValueViews) {
				formatString = "H:|[view]|"
				rootConstraints += NSLayoutConstraint.constraintsWithVisualFormat(formatString, options: .allZeros, metrics: nil, views: ["view" : titleValueView])
				if (index == 0) {
					formatString = "V:|[view]"
					rootConstraints += NSLayoutConstraint.constraintsWithVisualFormat(formatString, options: .allZeros, metrics: nil, views: ["view" : titleValueView])
				} else {
					let viewAbove = titleValueViews[index-1]
					formatString = "V:|[viewAbove][view]"
					rootConstraints += NSLayoutConstraint.constraintsWithVisualFormat(formatString, options: .allZeros, metrics: nil, views: ["viewAbove" : viewAbove, "view" : titleValueView])
				}
			}
			if (titleValueViews.count > 0) {
				let lastView = titleValueViews[titleValueViews.count - 1]
				formatString = "V:[lastView]|"
				rootConstraints += NSLayoutConstraint.constraintsWithVisualFormat(formatString, options: .allZeros, metrics: nil, views: ["lastView" : lastView])
				addConstraints(rootConstraints)
			}
		}
		super.updateConstraints()
	}
	
}
