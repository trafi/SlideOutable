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
public class ClearContainerView: UIView {
    
    public weak var viewForClearTouches: UIView?

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let superHit = super.hitTest(point, with: event)
        guard backgroundColor == nil || backgroundColor == .clear else { return superHit }
        
        return self == superHit ? viewForClearTouches?.hitTest(point, with: event) : superHit
    }
}
