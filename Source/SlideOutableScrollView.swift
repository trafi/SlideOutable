//
//  SlideOutableScrollView.swift
//  SlideOutable
//
//  Created by Domas Nutautas on 20/05/16.
//  Copyright © 2016 Domas Nutautas. All rights reserved.
//

import UIKit

// MARK: - SlideOutable UIScrollView

final class SlideOutScrollView: UIScrollView, SlideOutable {
    
    // MARK: SlideOutable conformance
    
    weak var paddingDelegate: SlidePaddingDelegate? {
        didSet {
            didLayout()
        }
    }
    var position = SlideOutablePosition.dynamic(visiblePart: 120) {
        didSet {
            updateContentInset()
        }
    }
    var scrollView: UIScrollView {
        return self
    }
    
    // MARK: Methods forwarding
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let point = slideOutPointInside(point) else { return false }
        return super.point(inside: point, with: event)
    }
    
    override var frame: CGRect {
        didSet {
            updateContentInset()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        didLayout()
    }
}

// MARK: - SlideOutable UITableView

final class SlideOutTableView: UITableView, SlideOutable {
    
    // MARK: SlideOutable conformance
    
    weak var paddingDelegate: SlidePaddingDelegate? {
        didSet {
            didLayout()
        }
    }
    var position = SlideOutablePosition.dynamic(visiblePart: 120) {
        didSet {
            updateContentInset()
        }
    }
    var scrollView: UIScrollView {
        return self
    }
    
    // MARK: Methods forwarding
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let point = slideOutPointInside(point) else { return false }
        return super.point(inside: point, with: event)
    }
    
    override var frame: CGRect {
        didSet {
            updateContentInset()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        didLayout()
    }
}
