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
    
    private var downStreet:DownStreet
    private var upStreet:UpStreet
    private var midline:Int
    
    init (midline: Int) {
        self.midline = midline
        downStreet = DownStreet(streetPos: midline + 15)
        upStreet = UpStreet(streetPos: midline - 15)
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

