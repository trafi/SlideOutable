//
//  IBSlideOutable.swift
//  Trafi
//
//  Created by Domas on 15/12/2016.
//  Copyright © 2016 Intelligent Communications. All rights reserved.
//

import SlideOutable

class IBSlideOutable: SlideOutable {
    
    /**
     The top padding that contents will not scroll on.
     
     Animatable.
     
     The default value is `0`.
     */
    @IBInspectable dynamic override var topPadding: CGFloat { didSet {} }
    
    
    /**
     The mid anchor fraction from `0` (the very bottom) to `1` the very top of the `SlideOutable` view bounds. Setting it to `nil` would disable the anchoring.
     
     Animatable.
     
     The default value is `0.4`.
     */
    @IBInspectable override var anchorFraction: CGFloat? { didSet {} }
    
    /**
     The minimum content visible content (header and scroll) height.
     
     Animatable.
     
     The default value is header's `bounds.height` or `120` if header is not set.
     */
    @IBInspectable dynamic override var minContentHeight: CGFloat { didSet {} }
    
    /**
     Proxy for `minimumContentHeight` without header's `bounds.height`.
     
     Animatable.
     */
    @IBInspectable override var minScrollHeight: CGFloat { didSet {} }
    
    /**
     Determens weather the scroll's `bounds.height` can get bigger than it's `contentSize.height`.
     
     Animatable.
     
     The default value is `true`.
     */
    @IBInspectable override var isScrollStretchable: Bool { didSet {} }
    
    
    @IBOutlet override var header: UIView? { didSet {} }
    @IBOutlet override var scroll: UIScrollView! { didSet {} }
}
