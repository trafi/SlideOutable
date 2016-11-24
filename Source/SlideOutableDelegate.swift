//
//  SlideOutableDelegate.swift
//  SlideOutableExample
//
//  Created by Domas on 24/11/2016.
//  Copyright © 2016 Domas. All rights reserved.
//

import Foundation

public protocol SlideOutableDelegate: class {
    func slideOutable(_ slideOutable: SlideOutable, stateChanged state: SlideOutable.State)
}
