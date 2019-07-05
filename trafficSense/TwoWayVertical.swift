//
//  TwoWayVertical.swift
//  trafficSense
//
//  Created by Rajat Mittal on 7/4/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import UIKit

class TwoWayVertical {
    // contains two streets going in opposite directions, one going up and one going down
    private var downStreet:DownStreet
    private var upStreet:UpStreet
    private var midline:Int
    
    init (midline: Int) {
        self.midline = midline
        downStreet = DownStreet(streetPos: midline - 30)
        upStreet = UpStreet(streetPos: midline + 30)
    }
    
    func getDownStreet() -> DownStreet {
        return downStreet
    }
    
    func getUpStreet() -> UpStreet {
        return upStreet
    }
    
    func getMidline() -> Int {
        return midline
    }
}

