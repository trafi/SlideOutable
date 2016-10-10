//
//  ViewController.swift
//  Scroller
//
//  Created by Domas Nutautas on 19/05/16.
//  Copyright © 2016 Domas Nutautas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SlidePaddingDelegate {

    // MARK: Options
    
    @IBAction private func toggleOptionsTapped() {
        let hide = !resetTableButton.isHidden
        UIView.animate(withDuration: 0.3) {
            [self.resetTableButton, self.resetViewButton, self.toggleScrollLockButton].forEach {
                $0?.isHidden = hide
                $0?.alpha = hide ? 0 : 1
            }
        }
    }
    
    // MARK: Change VC
    
    @IBOutlet private var resetTableButton: UIButton!
    
    private var tableData = TableData(items: [String](repeating: "Item", count: 5))
    
    @IBAction private func resetTableTapped() {
        
        tableData = TableData(items: [String](repeating: "Item \(vcIndex)", count: 5))
        
        setTableDataAsContent()
        
        vcIndex += 1
    }
    
    private func setTableDataAsContent() {
        slideOutVC.setContent(
            .table(tableData, configure: {
                $0.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 20))
            })
        )
    }
    
    private var vcIndex = 1 // For mocking data

    @IBOutlet var resetViewButton: UIButton!
    
    @IBAction func resetViewTapped() {
        
        let label = UILabel()
        
        label.backgroundColor = .white
        label.numberOfLines = 0
        
        label.text = "Item \(vcIndex)\n Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        let container = UIView()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        label.topAnchor   .constraint(equalTo: container.topAnchor,    constant:  20).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20).isActive = true
        
        label.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        label.leadingAnchor .constraint(equalTo: container.leadingAnchor ).isActive = true
        
        slideOutVC.setContent(.view(container))
        
        vcIndex += 1
    }
    
    
    // MARK: Lock scroll
    
    @IBOutlet private var toggleScrollLockButton: UIButton!
    private var scrollOpened = false
    
    @IBAction private func toggleScrollLockTapped() {
        scrollOpened = !scrollOpened
        slideOutVC.setPosition(scrollOpened ? .opened : .dynamic(visiblePart: 120))
    }
    

    // MARK: Peak table
    
    private var slideOutVC: SlideOutableViewController! {
        didSet {
            setTableDataAsContent()
            slideOutVC.setPaddingDelegate(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        slideOutVC = segue.destination as? SlideOutableViewController
    }
    
    // MARK: Top padding
    
    @IBOutlet private var topBackgroundView: UIView!
    @IBOutlet private var bottomBackgroundView: UIView!
    @IBOutlet private var bottomBackgroundPaddingConstraint: NSLayoutConstraint!
    
    func topPaddingDidChange(_ padding: CGFloat) {
        
        topBackgroundView.alpha = max(1 - padding/30, 0)
        
        bottomBackgroundPaddingConstraint.constant = padding
    }
    
}

// MARK: - TableViewDataSource

class TableData: NSObject, UITableViewDataSource, UITableViewDelegate {
    let items: [String]
    
    init(items: [String]) {
        self.items = items
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = items[(indexPath as NSIndexPath).row]
        
        return cell
    }
}
