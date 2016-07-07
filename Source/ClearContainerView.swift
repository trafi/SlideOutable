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
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        for subview in subviews where subview.point(inside: convert(point, to: subview), with: event) {
            return true
        }
        
        return false
    }
}
