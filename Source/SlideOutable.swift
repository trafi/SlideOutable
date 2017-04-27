//
//  SlideOutable.swift
//  SlideOutable
//
//  Created by Domas Nutautas on 20/05/16.
//  Copyright © 2016 Domas Nutautas. All rights reserved.
//

import UIKit

// MARK: - SlideOutable Implementation

/// View that presents header and scroll in a sliding manner.
open class SlideOutable: ClearContainerView {
    
    // MARK: Init
    
    /**
     Initializes and returns a newly allocated SlideOutable view object with specified scroll element.
     
     - Parameter frame: The `CGRect` to be passed for `UIView(frame:)` initializer. Defaults to `.zero`.
     - Parameter scroll: The `UIScrollView` that will be layed out in `SlideOutable` view's hierarchy.
     - Parameter header: The `UIView` to be added as a header above scroll - will be visible at all times. Make sure it's `bounds.height` is greater than 0 - it will be used as initial value for `minContentHeight`. Defaults to `nil`.
     
     - Returns: An initialized `SlideOutable` view object with `scroll` and optional `header` layed out in it's view hierarchy.
     */
    public init(frame: CGRect = .zero, scroll: UIScrollView, header: UIView? = nil) {
        
        super.init(frame: frame)
        
        self.header = header
        self.scroll = scroll
        self.lastScrollOffset = scroll.contentOffset.y
        
        setupIfNeeded()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupIfNeeded()
    }
    
    
    private var needsSetup = true
    private func setupIfNeeded() {
        
        guard needsSetup else { return }
        needsSetup = false
        
        // Setup
        
        backgroundColor = .clear
        
        // Scroll
        
        scroll.removeFromSuperview()
        scroll.translatesAutoresizingMaskIntoConstraints = true
        scroll.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        scroll.frame = CGRect(x: 0, y: bounds.height - scroll.bounds.height,
                              width: bounds.width, height: scroll.bounds.height)
        scroll.alwaysBounceVertical = true
        scroll.keyboardDismissMode = .onDrag
        addSubview(scroll)
        
        scroll.panGestureRecognizer.addTarget(self, action: #selector(SlideOutable.didPanScroll(_:)))
        
        scroll.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: &scrollContentContext)
        scroll.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: .new, context: &scrollContentContext)
        
        defer {
            updateScrollSize()
            update()
        }
        
        // Header
        
        guard let header = header else { return }
        
        assert(header.bounds.height >= 0, "`header` frame size height should be greater than 0")
        
        header.removeFromSuperview()
        header.translatesAutoresizingMaskIntoConstraints = true
        header.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        header.frame = CGRect(x: 0, y: scroll.frame.minY - header.bounds.height,
                              width: bounds.width, height: header.bounds.height)
        minContentHeight = header.bounds.height
        addSubview(header)
        
        header.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(SlideOutable.didPanDrag(_:))))
    }
    
    deinit {
        scroll?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), context: &scrollContentContext)
        scroll?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: &scrollContentContext)
    }
    
    // MARK: - Properties
    
    // MARK: Configurable

    /**
     The top padding that contents will not scroll on.
     
     Animatable.
     
     The default value is `0`.
     */
    @IBInspectable open dynamic var topPadding: CGFloat = 0 {
        didSet { update() }
    }
    
    /**
     The mid anchor fraction from `0` (the very bottom) to `1` the very top of the `SlideOutable` view bounds. Setting it to `nil` would disable the anchoring.
     
     Animatable.
     
     The default value is `0.4`.
     */
    @IBInspectable open var anchorFraction: CGFloat? = 0.4 {
        didSet { update() }
    }
    
    /**
     The minimum content visible content (header and scroll) height.
     
     Animatable.
     
     The default value is header's `bounds.height` or `120` if header is not set.
     */
    @IBInspectable open dynamic var minContentHeight: CGFloat = 120 {
        didSet { update() }
    }
    
    /**
     Proxy for `minimumContentHeight` without header's `bounds.height`.
     
     Animatable.
     */
    @IBInspectable open var minScrollHeight: CGFloat {
        get { return minContentHeight - (header?.bounds.height ?? 0) }
        set { minContentHeight = newValue + (header?.bounds.height ?? 0) }
    }
    
    /**
     Determens weather the scroll's `bounds.height` can get bigger than it's `contentSize.height`.
     
     Animatable.
     
     The default value is `true`.
     */
    @IBInspectable open var isScrollStretchable: Bool = true {
        didSet { update() }
    }
    
    /// The delegate of `SlideOutable` object.
    open weak var delegate: SlideOutableDelegate?
    
    // MARK: Private
    
    // UI
    @IBOutlet open var header: UIView?
    @IBOutlet open var scroll: UIScrollView!
    
    // Offsets
    var lastScrollOffset: CGFloat = 0
    var lastDragOffset: CGFloat = 0
    
    
    // MARK: Computed
    
    //header height
    public func setHeaderHeight(height: CGFloat) {
        header?.frame.size.height = height
        if let maxY = header?.frame.maxY {
            scroll.frame.origin.y = maxY
        }
    }
    
    /// Returns the current offest of `SlideOutable` object.
    public internal(set) var currentOffset: CGFloat {
        get {
            return (header ?? scroll).frame.minY
        }
        set {
            guard newValue != currentOffset else { return }
            
            // Save last state
            lastState = state(forOffset: newValue)
            
            if let headerHeight = delegate?.slideOutableHeaderHeight(for: currentOffset) {
                header?.frame.size.height = headerHeight
            }
            
            // Change state
            header?.frame.origin.y = newValue
            scroll.frame.origin.y = header?.frame.maxY ?? newValue
            
            // Notifies `delegate`
            delegate?.slideOutable(self, stateChanged: stateForDelegate)
        }
    }
    
    /// Returns the current visible height of `SlideOutable` object.
    public var currentVisibleHeight: CGFloat {
        return bounds.height - currentOffset
    }
    
    var minOffset: CGFloat { return isScrollStretchable ? topPadding : max(topPadding, bounds.height - (header?.bounds.height ?? 0) - scroll.contentSize.height) }
    var maxOffset: CGFloat { return max(minOffset, bounds.height - minContentHeight) }
    var anchorOffset: CGFloat? { return anchorFraction.flatMap { bounds.height * (1 - $0) } }
    
    var snapOffsets: [CGFloat] {
        return [maxOffset, anchorOffset].reduce([minOffset]) { offsets, offset in
            guard let offset = offset, offset > minOffset else { return offsets }
            return offsets + [offset]
        }
    }
    
    // MARK: - Scroll content size KVO
    
    private var scrollContentContext = 0
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &scrollContentContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard let keyPath = keyPath else { return }
        switch keyPath {
        case #keyPath(UIScrollView.contentOffset):
            guard lastScrollOffset != scroll.contentOffset.y else { return }
            scrollViewDidScroll(scroll)
        case #keyPath(UIScrollView.contentSize):
            guard !isScrollStretchable && !isAnyGestureActive else { return }
            update()
        default:
            break
        }
    }
    
    // MARK: - State
    
    /// The state options of `SlideOutable` content.
    public enum State {
        public enum Settle {
            /// The contents are fully expanded.
            case expanded
            /// The contents are anchored to specified `anchorPoint`.
            case anchored
            /// The contents are fully collapsed.
            case collapsed
        }
        /// The contents are settled in one of the `Settle` cases.
        case settled(Settle)
        /// The contents are being interacted with.
        case dragging(offset: CGFloat)
    }
    
    /**
     Sets the `SlideOutable` view's state to specified `Settle` case. If there is no `anchorFraction` specified then `.anchored` will be ignored.
     
     Animatable.
     */
    public func set(state: State.Settle) {
        lastState = .settled(state)
        guard let newOffset = offset(forState: state) else { return }
        currentOffset = newOffset
    }
    
    /// Returns the current state of `SlideOutable` view.
    public var state: State {
        return state(forOffset: currentOffset)
    }
    
    func state(forOffset offset: CGFloat) -> State {
        switch offset.equatable {
        case minOffset.equatable:
            return .settled(.expanded)
        case anchorOffset?.equatable ?? minOffset.equatable: // Makes compiler happy, dev sad :(
            return .settled(.anchored)
        case maxOffset.equatable:
            return .settled(.collapsed)
        default:
            return .dragging(offset: currentOffset)
        }
    }
    
    lazy var lastState: State = self.state
    
    func offset(forState state: State.Settle) -> CGFloat? {
        switch state {
        case .expanded:
            return minOffset
        case .anchored:
            return anchorOffset
        case .collapsed:
            return maxOffset
        }
    }
    
    var isAnyGestureActive: Bool {
        return scroll.panGestureRecognizer.isActive || header?.gestureRecognizers?.first { $0.isActive } != nil
    }
    
    var stateForDelegate: State {
        guard isAnyGestureActive else { return state }
        return .dragging(offset: currentOffset)
    }
    
    // MARK: - Interaction
    
    enum Interaction {
        case scroll
        case drag
        
        enum Direction {
            case up
            case down
        }
        
        init(direction: Direction, in state: State, scrolledToTop: Bool) {
            let scrollingToContentTop = !scrolledToTop && direction == .down
            if scrollingToContentTop {
                self = .scroll
            } else if case .settled(let settle) = state, settle == .expanded {
                switch direction {
                case .up:   self = .scroll
                case .down: self = .drag
                }
            } else {
                self = .drag
            }
        }
    }
    
    func interaction(forDirection direction: Interaction.Direction) -> Interaction {
        return Interaction(direction: direction, in: state, scrolledToTop: scroll.contentOffset.y <= 0)
    }
    func interaction(scrollView: UIScrollView) -> Interaction {
        // Enable bouncing
        if case .settled = state, scrollView.isDecelerating {
            return .scroll
        } else {
            return interaction(forDirection: lastScrollOffset > scrollView.contentOffset.y ? .down : .up)
        }
    }
    func interaction(pan: UIPanGestureRecognizer) -> Interaction {
        return interaction(forDirection: pan.velocity(in: pan.view).y > 0 ? .down : .up)
    }
    
    // MARK: - Updates
    
    open override var frame: CGRect {
        didSet {
            updateScrollSize()
            update()
        }
    }
    
    open override var bounds: CGRect {
        didSet {
            updateScrollSize()
            update()
        }
    }
    
    func updateScrollSize() {
        scroll?.frame.size = CGSize(width: bounds.width, height: bounds.height - (header?.bounds.height ?? 0) - topPadding)
    }
    
    func update(animated: Bool = false, to targetOffset: CGFloat? = nil, velocity: CGFloat? = nil, keepLastState: Bool = true) {
        
        guard scroll != nil else { return }
        
        // Get actual target
        let target: CGFloat
        if let targetOffset = targetOffset {
            target = targetOffset
        } else if keepLastState, case .settled(let settled) = lastState, let settledOffset = self.offset(forState: settled) {
            target = settledOffset
        } else {
            target = currentOffset
        }
        
        // Get actual offset
        let offset: CGFloat = snapOffsets.dropFirst().reduce(snapOffsets[0]) { closest, current in
            let closestDiff = abs(target - closest)
            let currentDiff = abs(target - current)
            return closestDiff < currentDiff ? closest : current
        }
        
        guard offset != currentOffset else { return }
        
        guard animated else {
            currentOffset = offset
            return
        }
        
        // Stop scroll decelerate
        scroll.stopDecelerating()
        
        // To make sure scroll bottom does not get higher than container bottom during animation spring bounce.
        let antiBounce: CGFloat = 1000
        scroll.frame.size.height += antiBounce
        scroll.contentInset.bottom += antiBounce
        
        // Animate to new height
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: velocity.flatMap { abs($0 / (currentOffset - offset)) } ?? 1,
                       options: .curveLinear,
                       animations: { self.currentOffset = offset },
                       completion: { _ in
                        self.updateScrollSize()
                        self.scroll.contentInset.bottom -= antiBounce
        })
    }
}

// MARK: - Scrolling

extension SlideOutable {
    fileprivate func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch interaction(scrollView: scrollView) {
        case .scroll:
            scrollView.scrollIndicatorInsets.bottom = max(0, scrollView.frame.maxY - bounds.height)
            scrollView.showsVerticalScrollIndicator = true
            lastScrollOffset = scrollView.contentOffset.y
        case .drag:
            if lastScrollOffset > 0 && 0 > scrollView.contentOffset.y {
                // Accounts for missed content offset switching from .scroll to .drag
                lastDragOffset += lastScrollOffset
                
                lastScrollOffset = 0
            }
            scrollView.showsVerticalScrollIndicator = false
            scrollView.contentOffset.y = lastScrollOffset
        }
    }
}

extension UIScrollView {
    func stopDecelerating() {
        setContentOffset(contentOffset, animated: false)
    }
}

extension SlideOutable {
    func didPanScroll(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            header?.gestureRecognizers?.first?.stopCurrentGesture()
        }
        
        switch interaction(pan: pan) {
        case .scroll:
            lastDragOffset = pan.translation(in: pan.view).y
            
            guard pan.state == .ended, case .dragging = state else { break }
            didPanDrag(pan)
            
        case .drag:
            // Forwards interaction
            didPanDrag(pan)
        }
    }
}

// MARK: - Dragging

extension SlideOutable {
    func offset(forDiff diff: CGFloat) -> (value: CGFloat, clipped: CGFloat)? {
        guard diff != 0 else { return nil }
        
        let targetOffset = currentOffset - diff
        let offset = min(maxOffset, max(minOffset, targetOffset))
        return (offset, offset - targetOffset)
    }
    
    func didPanDrag(_ pan: UIPanGestureRecognizer) {
        let dragOffset = pan.translation(in: pan.view).y
        var diff = lastDragOffset - dragOffset
        
        let isScrollPan = scroll.panGestureRecognizer == pan
        
        switch pan.state {
        case .began where !isScrollPan:
            scroll.panGestureRecognizer.stopCurrentGesture()
            
        case .changed:
            // If starts dragging while scroll is in a bounce
            if lastScrollOffset < 0 {
                if isScrollPan {
                    diff -= lastScrollOffset
                }
                lastScrollOffset = 0
                scroll.contentOffset.y = 0
            }
            
            guard let offset = offset(forDiff: diff) else { break }
            currentOffset = offset.value
            
            // Accounts for clipped pan switching from .drag to .scroll
            guard offset.clipped != 0, isScrollPan else { break }
            scroll.contentOffset.y += offset.clipped
            
        case .ended:
            let velocity = pan.velocity(in: pan.view).y
            let targetOffset = currentOffset - diff + 0.2 * velocity
            update(animated: true, to: targetOffset, velocity: velocity, keepLastState: false)
        default: break
        }
        
        lastDragOffset = dragOffset
    }
}

extension UIGestureRecognizer {
    func stopCurrentGesture() {
        isEnabled = !isEnabled
        isEnabled = !isEnabled
    }
    var isActive: Bool {
        return [.began, .changed].contains(state)
    }
}
