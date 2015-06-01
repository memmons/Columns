
//
//  TitleValueView.swift
//  Columns
//
//  Created by Michael Emmons on 5/11/15.
//  Copyright (c) 2015 Netsmart Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

@objc public class METitleValueView : UIView {

	private var customConstraintsInstalled = false
	private let titleWidth : Float
	private let minimumHeight : Float
	private let titleLabel : UILabel
	private let valueLabel : UILabel
	private let divider1 = UIView()
	private let divider2 = UIView()

	init(titleLabel: UILabel,  valueLabel: UILabel, titleWidth: Float, minimumHeight: Float) {
		self.titleLabel = titleLabel
		self.valueLabel = valueLabel
		self.titleWidth = titleWidth
		self.minimumHeight = minimumHeight
		super.init(frame: CGRectZero)
		setTranslatesAutoresizingMaskIntoConstraints(false)
		configure()
	}

	required public init(coder aDecoder: NSCoder) {
	    fatalError("NSCoding not supported. Class must be created programatically.")
	}


	private func configure() {
		titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .Right

		valueLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		valueLabel.numberOfLines = 0
		valueLabel.lineBreakMode = .ByWordWrapping

		divider1.setTranslatesAutoresizingMaskIntoConstraints(false)
		divider1.backgroundColor = UIColor(red: 171.0/255.0, green: 181.0/255.0, blue: 184.0/255.0, alpha: 1.0)

		divider2.setTranslatesAutoresizingMaskIntoConstraints(false)
		divider2.backgroundColor = UIColor.whiteColor()

		addSubview(titleLabel)
		addSubview(valueLabel)
		addSubview(divider1)
		addSubview(divider2)
	
	}

	private func constraintsWithVisualFormat(visualFormat: String) -> Array<AnyObject> {

		let viewsDictionary = ["titleLabel" : titleLabel, "valueLabel" : valueLabel, "divider1" : divider1, "divider2" : divider2]
		let metricDictionary = ["titleLabelWidth" : titleWidth, "minimumHeight" : minimumHeight, "divider1" : NSNumber(float:1), "divider2" : NSNumber(float:1)]
		return NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: .allZeros, metrics: metricDictionary, views: viewsDictionary)
	}

	public override func updateConstraints() {
		if (customConstraintsInstalled == false) {
			customConstraintsInstalled = true
			removeConstraints(constraints())

			let viewsDictionary = ["titleLabel" : titleLabel, "valueLabel" : valueLabel, "divider1" : divider1, "divider2" : divider2]
			let metricDictionary = ["titleLabelWidth" : titleWidth, "minimumHeight" : minimumHeight, "divider1" : NSNumber(float:1), "divider2" : NSNumber(float:1)]
			var rootConstraints = Array<AnyObject>()

			var formatString = "H:|-5-[titleLabel(==titleLabelWidth)]-10-[valueLabel]|"
			rootConstraints += constraintsWithVisualFormat(formatString)

			formatString = "V:|[titleLabel(>=minimumHeight@999)]|"
			rootConstraints += constraintsWithVisualFormat(formatString)

			formatString = "V:|[valueLabel]|"
			rootConstraints += constraintsWithVisualFormat(formatString)

			formatString = "H:|[divider1]|"
			rootConstraints += constraintsWithVisualFormat(formatString)

			formatString = "H:|[divider2]|"
			rootConstraints += constraintsWithVisualFormat(formatString)

			formatString = "V:[divider1(==divider1@999)][divider2(==divider2@999)]|"
			rootConstraints += constraintsWithVisualFormat(formatString)

			addConstraints(rootConstraints)
		}
		super.updateConstraints()
	}

}
