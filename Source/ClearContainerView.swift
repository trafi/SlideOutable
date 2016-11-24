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
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        guard backgroundColor == .clear else { return super.point(inside: point, with: event) }
        
        for subview in subviews where subview.point(inside: convert(point, to: subview), with: event) {
            return true
        }
        
        return false
    }
}
