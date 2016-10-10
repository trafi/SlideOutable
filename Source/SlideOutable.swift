//
//  SlideOutable.swift
//  SlideOutable
//
//  Created by Domas Nutautas on 20/05/16.
//  Copyright © 2016 Domas Nutautas. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol SlideOutable {
    var paddingDelegate: SlidePaddingDelegate? { get set }
    var position: SlideOutablePosition { get set }
    var scrollView: UIScrollView { get }
}

public protocol SlidePaddingDelegate: class {
    func topPaddingDidChange(_ padding: CGFloat)
}

public enum SlideOutablePosition {
    case opened
    case dynamic(visiblePart: CGFloat)
}

// MARK: SlideOutable Implementation

extension SlideOutable {
    
    ///
    /// Updates `scrollView`'s `contentInset`.
    /// Should be called on `frame` and `position` changes.
    ///
    func updateContentInset() {
        
        switch position {
        case .opened: scrollView.contentInset.top = 0
        case .dynamic(let visible):
            let topInset = scrollView.frame.height - visible
            
            scrollView.contentOffset.y += scrollView.contentInset.top - topInset
            scrollView.contentInset.top = topInset
        }
    }
    
    ///
    /// Response should be used in `scrollView`'s `pointInside:withEvent:` function.
    ///
    func slideOutPointInside(_ point: CGPoint) -> CGPoint? {
        guard point.y > 0 else { return nil }
        
        return CGPoint(x: scrollView.frame.midX, y: point.y) // Ingores horizontal point's position
    }
    
    ///
    /// Should be called from `scrollView`'s `layoutSubviews` function.
    ///
    func didLayout() {
        
        let visibleTopPadding: CGFloat
        switch position {
        case .opened: visibleTopPadding = 0
        case .dynamic: visibleTopPadding = max(-scrollView.contentOffset.y, 0)
        }
        
        paddingDelegate?.topPaddingDidChange(visibleTopPadding)
    }
    
}
