//
//  ColumnTableViewCell.swift
//  Columns
//
//  Created by Michael Emmons on 4/26/15.

import UIKit


public class MEColumnTableViewCell: UITableViewCell {
	let kColumnLabelBaseTag			= 100
	let kColumnGlyphBaseTag			= 150
	let kRightPaddingViewTag			= 80
	let kBottomPaddingViewBaseTag	= 81
	let kRightPaddingViewKey			= "rightPaddingView"
	let kRootContainerViewKey		= "rootContainerView"
	let kExpandedContainerViewKey	= "expandedContainerView"
	let kExpandedImageViewKey		= "expandedImageView"

	var isExpanded = false
	var hasUpdatedConstraints = false

	var columnConfigurations : Array<MEColumnConfiguration> = []
	var metricDictionary = Dictionary<NSObject, AnyObject>()
	var viewsDictionary = Dictionary<NSObject, AnyObject>()

	var rootContainerView = UIView()
	var expandedContainerView = UIView()
	var expandedImageView = UIImageView(image:UIImage(named: "arrow"))
	var titleValueViews : METitleValueViews?
	var expandedConstraints = [AnyObject]()
	var collapsedConstraints = [AnyObject]()

	// MARK: - Initialization
	init(columns: Array<MEColumnConfiguration>, reuseIdentifier: String?) {
		super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
	}

	required public init(coder aDecoder: NSCoder) {
		fatalError("NSCoding not supported. Class must be created programatically.")
	}

	required override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		clipsToBounds = true

		expandedContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
		contentView.addSubview(expandedContainerView)

		rootContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
		rootContainerView.backgroundColor = UIColor(white:0.95, alpha:1)
		contentView.addSubview(rootContainerView)

		expandedImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
		expandedImageView.contentMode = UIViewContentMode.Center
		contentView.addSubview(expandedImageView)
	}

	public override func prepareForReuse() {
		contentView.removeConstraints(expandedConstraints)
		contentView.removeConstraints(collapsedConstraints)
		expandedContainerView.removeConstraints(expandedContainerView.constraints())

		isExpanded = false
		hasUpdatedConstraints = false;
		columnConfigurations = []
		metricDictionary = [:]
		viewsDictionary = [:]
		expandedConstraints = []
		collapsedConstraints = []
		super.prepareForReuse()
	}

	public func configure(columns: Array<MEColumnConfiguration>, titleValueViews: METitleValueViews, isExpanded: Bool) -> () {
		columnConfigurations = columns
		self.titleValueViews = titleValueViews
		self.isExpanded = isExpanded
		rootContainerView.subviews.map({ $0.removeFromSuperview() })
		expandedContainerView.subviews.map({ $0.removeFromSuperview() })

		for (index, element) in enumerate(columns) {
			element.view.setTranslatesAutoresizingMaskIntoConstraints(false)
			rootContainerView.addSubview(element.view)

			let columnGlyph = UIView()
			columnGlyph.setTranslatesAutoresizingMaskIntoConstraints(false)
			columnGlyph.tag = index+kColumnGlyphBaseTag
			columnGlyph.backgroundColor = element.separatorColor ?? .grayColor()
			rootContainerView.addSubview(columnGlyph)
		}
		let rightPaddingView = UIView()
		rightPaddingView.backgroundColor = .greenColor()
		rightPaddingView.setTranslatesAutoresizingMaskIntoConstraints(false)
		rightPaddingView.tag = kRightPaddingViewTag
		rootContainerView.addSubview(rightPaddingView)
		expandedContainerView.addSubview(titleValueViews)
		hasUpdatedConstraints = false
		expand(isExpanded, animated:false)
	}

	// MARK: - Public Methods
	public func expand(isExpanded : Bool, animated: Bool) {

		self.isExpanded = isExpanded
		let interval = animated == true ? 0.35 : 0.0
		setNeedsUpdateConstraints()
		UIView.animateWithDuration(interval) {
			self.transformImageViewForExpansion(isExpanded)
			self.layoutIfNeeded()
		}
	}


	// MARK: - Private helpers
	private func transformImageViewForExpansion(isExpanded : Bool) {
		let transform : CGAffineTransform
		if (isExpanded == true) {
			transform = CGAffineTransformMakeRotation(CGFloat((angle:90 * M_PI / 180)))
		} else {
			transform = CGAffineTransformIdentity
		}
		expandedImageView.transform = transform;
	}

	private func changeAlphaForExpansion(isExpanded: Bool) {
		expandedContainerView.alpha = isExpanded ? 1.0 : 0.0
	}


	private func configureConstraintDictionaries() -> () {
		var metricDictionary = Dictionary<NSObject, AnyObject>()
		var viewDictionary = Dictionary<NSObject, AnyObject>()

		for (index, element) in enumerate(columnConfigurations) {
			let keys = keysForColumnIndex(index)
			let glyphView = rootContainerView.viewWithTag(index+kColumnGlyphBaseTag)
			let bPaddingView = rootContainerView.viewWithTag(index+kBottomPaddingViewBaseTag)

			metricDictionary[keys.viewKey] = element.minWidth
			metricDictionary[keys.columnGlyphKey] = element.separatorWidth ?? NSNumber(float:1)
			viewDictionary[keys.viewKey] = element.view
			viewDictionary[keys.columnGlyphKey] = glyphView!
//			viewDictionary[keys.paddingKey] = bPaddingView!
		}
		let rPaddingView = rootContainerView.viewWithTag(kRightPaddingViewTag)
		viewDictionary[kRootContainerViewKey] = rootContainerView
		viewDictionary[kExpandedContainerViewKey] = expandedContainerView
		viewDictionary[kExpandedImageViewKey] = expandedImageView
		viewDictionary[kRightPaddingViewKey] = rPaddingView!
		viewDictionary["titleValueViews"] = titleValueViews

		self.metricDictionary = metricDictionary
		self.viewsDictionary = viewDictionary
	}


	private func keysForColumnIndex(index: Int) -> (viewKey: String, columnGlyphKey: String, paddingKey: String) {
		return (String(format: "view%i", index), String(format: "columnGlyph%i", index), String(format: "paddingView%i", index))
	}

	// MARK: - Autolayout
	private func constraintsWithVisualFormat(visualFormat: String) -> Array<AnyObject> {

		return NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: .allZeros, metrics: metricDictionary, views: viewsDictionary)
	}

	public override func updateConstraints() {
		if (hasUpdatedConstraints == false) {
			hasUpdatedConstraints = true
			contentView.removeConstraints(constraints())
			rootContainerView.removeConstraints(rootContainerView.constraints())

			configureConstraintDictionaries()
			expandedConstraints = constraintsWithVisualFormat("V:|[rootContainerView][expandedContainerView]|")
			collapsedConstraints = constraintsWithVisualFormat("V:|[rootContainerView][expandedContainerView(==0)]|")

			var rootConstraints = Array<AnyObject>()
			rootConstraints += constraintsWithVisualFormat("V:|-5-[expandedImageView(==12)]")
			rootConstraints += constraintsWithVisualFormat("H:|-5-[expandedImageView(==9)][rootContainerView]|")
			rootConstraints += constraintsWithVisualFormat("H:|-5-[expandedImageView][expandedContainerView]|")
			contentView.addConstraints(rootConstraints)

			var hFormatString = "H:|"
			var containerConstraints = Array<AnyObject>()
			for (index, element) in enumerate(columnConfigurations) {
				let keys = keysForColumnIndex(index)
				containerConstraints += constraintsWithVisualFormat(String(format:"V:|[%@]|", keys.viewKey))
				containerConstraints += constraintsWithVisualFormat(String(format:"V:|[%@]|", keys.columnGlyphKey))
				hFormatString += String(format:"[%@(==%@@999)][%@(==%@@999)]", keys.viewKey, keys.viewKey, keys.columnGlyphKey, keys.columnGlyphKey)
			}
			hFormatString += String(format: "[%@]|", kRightPaddingViewKey)
			containerConstraints += constraintsWithVisualFormat(hFormatString)
			rootContainerView.addConstraints(containerConstraints)

			var tvConstraints = Array<AnyObject>()
			tvConstraints += constraintsWithVisualFormat("H:|[titleValueViews]|")
			tvConstraints += constraintsWithVisualFormat("V:|[titleValueViews]|")
			expandedContainerView.addConstraints(tvConstraints)
		}
		contentView.removeConstraints(expandedConstraints)
		contentView.removeConstraints(collapsedConstraints)
		contentView.addConstraints(isExpanded == true ? expandedConstraints : collapsedConstraints)
		super.updateConstraints()
	}
}
