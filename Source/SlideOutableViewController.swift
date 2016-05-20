//
//  SlideOutableViewController.swift
//  SlideOutable
//
//  Created by Domas Nutautas on 20/05/16.
//  Copyright © 2016 Domas Nutautas. All rights reserved.
//

import UIKit

class SlideOutableViewController: UIViewController {

    // MARK: - Configuration
    
    // MARK: Content
    
    func setContent(newContent: Content) {
        guard content != nil else {
            content = newContent
            return
        }
        
        UIView.animateWithDuration(
            0.2, delay: 0, options: .CurveEaseIn,
            animations: {
                self.view.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.height)
            },
            completion: { _ in
                
                let animateOffset = self.slideOutable.scrollView.contentOffset.y < 0
                
                self.content = newContent
                
                self.slideOutable.scrollView.setContentOffset(
                    CGPoint(x: self.slideOutable.scrollView.contentOffset.x, y: 0),
                    animated: animateOffset)
                
                UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut,
                    animations: {
                        self.view.transform = CGAffineTransformIdentity
                    }, completion: nil)
        })
    }
    
    private var content: Content! {
        didSet {
            guard !content.reuse(slideOutable) else { return }
            slideOutable = content.createSlideOutable()
        }
    }
    
    private var slideOutable: SlideOutable! {
        didSet {
            slideOutable.paddingDelegate = oldValue?.paddingDelegate
            
            slideOutable?.scrollView.transform = view.transform
            slideOutable?.scrollView.autoresizingMask = view.autoresizingMask
            view = slideOutable?.scrollView
        }
    }
    
    // MARK: Padding
    
    func setPaddingDelegate(delegate: SlidePaddingDelegate) {
        slideOutable?.paddingDelegate = delegate
    }
    
    func setPosition(position: SlideOutablePosition) {
        UIView.animateWithDuration(0.3) {
            self.slideOutable?.position = position
        }
    }
    
    // MARK: - Content
    
    enum Content {
        
        typealias TableData = protocol<UITableViewDataSource, UITableViewDelegate>
        
        case Table(TableData, configure: ((UITableView)->())?)
        case View(UIView)
        
        // MARK: Creating
        
        private static func setup<T: SlideOutable>(slideOutable: T) -> T {
            slideOutable.scrollView.backgroundColor = .clearColor()
            slideOutable.scrollView.showsVerticalScrollIndicator = false
            return slideOutable
        }
        
        private func createSlideOutable() -> SlideOutable {
            switch self {
            case .Table(let data, let configure):
                let table = Content.configured(Content.setup(SlideOutTableView()), with: data)
                configure?(table)
                return table
            case .View(let view):
                return Content.configured(Content.setup(SlideOutScrollView()), with: view)
            }
        }
        
        private func reuse(slideOutable: SlideOutable?) -> Bool {
            guard let slideOutable = slideOutable else { return false }
            
            switch self {
            case .Table(let data, let configure):
                guard let tableView = slideOutable as? SlideOutTableView else { return false }
                
                Content.configured(tableView, with: data)
                configure?(tableView)
                tableView.reloadData()
                return true
                
            case .View(let view):
                guard let scrollView = slideOutable as? SlideOutScrollView else { return false }
                
                Content.configured(scrollView, with: view)
                return true
            }
        }
        
        // MARK: Configuring
        
        private static func configured(tableView: SlideOutTableView, with data: TableData) -> SlideOutTableView {
            tableView.delegate = data
            tableView.dataSource = data
            return tableView
        }
        
        private static func configured(scrollView: SlideOutScrollView, with view: UIView) -> SlideOutScrollView {
            // Cleans old subviews
            scrollView.subviews.forEach{ $0.removeFromSuperview() }
            
            // Adds new subview
            view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(view)
            let views = ["v": view, "s": scrollView]
            scrollView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|[v(==s)]|", options: [], metrics: nil, views: views) +
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|",      options: [], metrics: nil, views: views)
            )
            return scrollView
        }
    }
}
