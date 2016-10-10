//
//  SlideOutableScrollView.swift
//  SlideOutable
//
//  Created by Domas Nutautas on 20/05/16.
//  Copyright © 2016 Domas Nutautas. All rights reserved.
//

import UIKit

// MARK: - SlideOutable UIScrollView

public final class SlideOutScrollView: UIScrollView, SlideOutable {
    
    // MARK: SlideOutable conformance
    
    weak public  var paddingDelegate: SlidePaddingDelegate? {
        didSet {
            didLayout()
        }
    }
    public var position = SlideOutablePosition.dynamic(visiblePart: 120) {
        didSet {
            updateContentInset()
        }
    }
    var scrollView: UIScrollView {
        return self
    }
    
    // MARK: Methods forwarding
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let point = slideOutPointInside(point) else { return false }
        return super.point(inside: point, with: event)
    }
    
    override public var frame: CGRect {
        didSet {
            updateContentInset()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        didLayout()
    }
}

// MARK: - SlideOutable UITableView

public final class SlideOutTableView: UITableView, SlideOutable {
    
    // MARK: SlideOutable conformance
    
    weak public var paddingDelegate: SlidePaddingDelegate? {
        didSet {
            didLayout()
        }
    }
    public var position = SlideOutablePosition.dynamic(visiblePart: 120) {
        didSet {
            updateContentInset()
        }
    }
    var scrollView: UIScrollView {
        return self
    }
    
    // MARK: Methods forwarding
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let point = slideOutPointInside(point) else { return false }
        return super.point(inside: point, with: event)
    }
    
    override public var frame: CGRect {
        didSet {
            updateContentInset()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        didLayout()
    }
}
