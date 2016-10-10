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
    
    func setContent(_ newContent: Content) {
        guard content != nil else {
            content = newContent
            return
        }
        
        UIView.animate(
            withDuration: 0.2, delay: 0, options: .curveEaseIn,
            animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            },
            completion: { _ in
                
                let animateOffset = self.slideOutable.scrollView.contentOffset.y < 0
                
                self.content = newContent
                
                self.slideOutable.scrollView.setContentOffset(
                    CGPoint(x: self.slideOutable.scrollView.contentOffset.x, y: 0),
                    animated: animateOffset)
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut,
                    animations: {
                        self.view.transform = CGAffineTransform.identity
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
    
    func setPaddingDelegate(_ delegate: SlidePaddingDelegate) {
        slideOutable?.paddingDelegate = delegate
    }
    
    func setPosition(_ position: SlideOutablePosition) {
        UIView.animate(withDuration: 0.3) {
            self.slideOutable?.position = position
        }
    }
    
    // MARK: - Content
    
    enum Content {
        
        typealias TableData = UITableViewDataSource & UITableViewDelegate
        
        case table(TableData, configure: ((UITableView)->())?)
        case view(UIView)
        
        // MARK: Creating
        
        private static func setup<T: SlideOutable>(_ slideOutable: T) -> T {
            slideOutable.scrollView.backgroundColor = .clear
            slideOutable.scrollView.showsVerticalScrollIndicator = false
            return slideOutable
        }
        
        fileprivate func createSlideOutable() -> SlideOutable {
            switch self {
            case .table(let data, let configure):
                let table = Content.configured(Content.setup(SlideOutTableView()), with: data)
                configure?(table)
                return table
            case .view(let view):
                return Content.configured(Content.setup(SlideOutScrollView()), with: view)
            }
        }
        
        fileprivate func reuse(_ slideOutable: SlideOutable?) -> Bool {
            guard let slideOutable = slideOutable else { return false }
            
            switch self {
            case .table(let data, let configure):
                guard let tableView = slideOutable as? SlideOutTableView else { return false }
                
                Content.configure(tableView, with: data)
                configure?(tableView)
                tableView.reloadData()
                return true
                
            case .view(let view):
                guard let scrollView = slideOutable as? SlideOutScrollView else { return false }
                
                Content.configure(scrollView, with: view)
                return true
            }
        }
        
        // MARK: Configuring
        
        private static func configure(_ tableView: SlideOutTableView, with data: TableData) {
            tableView.delegate = data
            tableView.dataSource = data
        }
        
        private static func configured(_ tableView: SlideOutTableView, with data: TableData) -> SlideOutTableView {
            configure(tableView, with: data)
            return tableView
        }
        
        
        private static func configure(_ scrollView: SlideOutScrollView, with view: UIView) {
            // Cleans old subviews
            scrollView.subviews.forEach{ $0.removeFromSuperview() }
            
            // Adds new subview
            view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(view)
            let views = ["v": view, "s": scrollView]
            scrollView.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[v(==s)]|", options: [], metrics: nil, views: views) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|",      options: [], metrics: nil, views: views)
            )
        }
        
        private static func configured(_ scrollView: SlideOutScrollView, with view: UIView) -> SlideOutScrollView {
            configure(scrollView, with: view)
            return scrollView
        }
        
    }
}
