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
/// Passes touches if point is not inside one of its subviews
///
final class ClearContainerView: UIView {
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        
        for subview in subviews where subview.pointInside(convertPoint(point, toView: subview), withEvent: event) {
            return true
        }
        
        return false
    }
}