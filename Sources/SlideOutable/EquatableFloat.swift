//
//  EquatableFloat.swift
//  EquatableFloat
//
//  Created by Domas Nutautas on 11/01/17.
//  Copyright © 2017 Domas Nutautas. All rights reserved.
//

import Foundation

struct EquatableFloat: Equatable {
    let float: CGFloat
    static func ==(lhs: EquatableFloat, rhs: EquatableFloat) -> Bool {
        return abs(lhs.float - rhs.float) < 1e-6
    }
}

extension CGFloat {
    var equatable: EquatableFloat {
        return EquatableFloat(float: self)
    }
}
