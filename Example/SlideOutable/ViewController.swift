//
//  ViewController.swift
//  Scroller
//
//  Created by Domas Nutautas on 19/05/16.
//  Copyright © 2016 Domas Nutautas. All rights reserved.
//

import UIKit
import SlideOutable

class ViewController: UIViewController {

    @IBOutlet var container: SlideOutable! {
        didSet { container.delegate = self }
    }
    
    let cells = ["Vilnius", "New York", "San Francisco", "Paris", "Berlin", "London", "Madrid", "Rome", "Mumbai", "Buenos Aires", "Oslo", "Helsinki"]
}

extension ViewController: SlideOutableDelegate {
    func slideOutable(_ slideOutable: SlideOutable, stateChanged state: SlideOutable.State) {
        let alpha: CGFloat
        switch state {
        case .settled(let position):
            switch position {
            case .expanded:
                alpha = 0.5
            default:
                alpha = 0
            }
        case .dragging(let offset):
            alpha = max(0, 0.5 * (200 - offset) / 200)
        }
        
        slideOutable.backgroundColor = UIColor(white: 0, alpha: alpha)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cells[indexPath.row]
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut,
                       animations: { self.container.set(state: .expanded) },
                       completion: nil)
    }
}
