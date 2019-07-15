//
//  TwoWayVertical.swift
//  trafficSense
//
//  Created by Rajat Mittal on 7/4/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TwoWayVertical {
    // contains two streets going in opposite directions, one going up and one going down
    private var downStreet:DownStreet
    private var upStreet:UpStreet
    private var midline:Int
    private var streetNode:SKSpriteNode
    
    init (midline: Int) {
        streetNode = SKSpriteNode(imageNamed: "streetImageVertical")
        streetNode.size = CGSize(width: 120.0, height: 800.0)
        streetNode.zPosition = 0
        streetNode.position = CGPoint(x: midline, y: 0)
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
    
    func getNode() -> SKSpriteNode {
        return streetNode
    }
}

