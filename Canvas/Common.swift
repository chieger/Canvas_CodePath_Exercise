//
//  Common.swift
//  Canvas
//
//  Created by Charles Hieger on 5/23/15.
//  Copyright (c) 2015 Charles Hieger. All rights reserved.
//

import Foundation
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
