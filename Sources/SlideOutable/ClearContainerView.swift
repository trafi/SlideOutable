//
//  ClearContainerView.swift
//  SlideOutable
//
//  Created by Domas Nutautas on 20/05/16.
//  Copyright © 2016 Domas Nutautas. All rights reserved.
//

import UIKit

// MARK: - ContainterView

///
/// Passes touches if background is clear and point is not inside one of its subviews
///
open class ClearContainerView: UIView {
    
    open weak var viewForClearTouches: UIView?

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let superHit = super.hitTest(point, with: event)
        guard
            backgroundColor == nil || backgroundColor == .clear,
            self == superHit
        else { return superHit }

        return viewForClearTouches?.hitTest(convert(point, to: viewForClearTouches), with: event)
    }
}
