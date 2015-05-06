//
//  Layout.swift
//  DragImageBug-TEST
//
//  Created by dnguyen on 5/5/15.
//  Copyright (c) 2015 test. All rights reserved.
//

import Foundation
import UIKit

class Layout : Comparable {
    
    var center: CGPoint!
    var tag: Int!
    
    init() {
    }
    
    init(center: CGPoint, tag: Int) {
        self.center = center
        self.tag = tag
    }
}

// To find the index of this object in an array, find(array, item)

// This is needed to conform to Comparable protocal
func == (lhs: Layout, rhs: Layout) -> Bool {
    return lhs.tag == rhs.tag
}

//This is needed to conform to Comparable protocal
func < (lhs: Layout, rhs: Layout) -> Bool {
    return lhs.tag < rhs.tag
}
